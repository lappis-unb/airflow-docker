FROM apache/airflow:2.7.3-python3.10 as airflow-base

USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         build-essential \
         libgtk2.0-dev \
         libgdal-dev \
         unixodbc-dev \
         libpq-dev \
         vim \
         unzip \
         git \
  && sed -i 's,^\(MinProtocol[ ]*=\).*,\1'TLSv1.0',g' /etc/ssl/openssl.cnf \
  && sed -i 's,^\(CipherString[ ]*=\).*,\1'DEFAULT@SECLEVEL=1',g' /etc/ssl/openssl.cnf \
  && curl -O http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil/ACcompactado.zip \
  && unzip ACcompactado.zip -d /usr/local/share/ca-certificates/ \
  && update-ca-certificates \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base \
  && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
  && sed -i 's/^# pt_BR.UTF-8 UTF-8$/pt_BR.UTF-8 UTF-8/g' /etc/locale.gen \
  && locale-gen en_US.UTF-8 pt_BR.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

USER airflow
WORKDIR ${AIRFLOW_HOME}
RUN mkdir ${AIRFLOW_HOME}/dags-data && \
    mkdir ${AIRFLOW_HOME}/dags-data/Notifications-Configs

FROM airflow-base as airflow-deploy-infra

COPY requirements-uninstall.txt .
RUN pip uninstall -y -r requirements-uninstall.txt

RUN pip install --no-cache-dir --user $(curl https://gitlab.com/lappis-unb/decidimbr/servicos-de-dados/airflow-dags/-/raw/development/requirements.txt)

RUN rm ACcompactado.zip  requirements-uninstall.txt

FROM airflow-base as airflow-local

COPY ./airflow-docker/requirements-uninstall.txt .
RUN pip uninstall -y -r requirements-uninstall.txt

COPY ./airflow-dags/requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

RUN rm ACcompactado.zip requirements.txt requirements-uninstall.txt

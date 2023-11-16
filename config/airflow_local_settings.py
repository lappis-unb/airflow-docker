from datetime import timedelta

from airflow.exceptions import AirflowClusterPolicyViolation


def dag_policy(dag):
    # Set task instances allowed concurrently max 8
    dag.max_active_tasks = (
        8
        if not dag.max_active_tasks or dag.max_active_tasks > 8
        else dag.max_active_tasks
    )

    # Set dag concurrency max to 1
    dag.max_active_runs = 1

    # Set dagrun_timeout max to 1 day
    dag.dagrun_timeout = (
        timedelta(days=1)
        if not dag.dagrun_timeout or dag.dagrun_timeout > timedelta(days=1)
        else dag.dagrun_timeout
    )

    # Check if owner exists
    if not dag.default_args.get("owner", None):
        raise AirflowClusterPolicyViolation("Missing DAG default_arg `owner`.")

    # Check if dag has tags
    if not dag.tags:
        raise AirflowClusterPolicyViolation(
            f"DAG has no tags. At least one tag required."
        )
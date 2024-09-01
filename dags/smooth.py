from airflow.decorators import dag
from airflow.operators.dummy import DummyOperator
from datetime import datetime

@dag(
    schedule=None,
    start_date=datetime(2023, 1, 1),
    catchup=False,
    tags=["smooth"],
)
def smooth():
    video = DummyOperator(
        task_id="youtube_video"
    )

smooth()

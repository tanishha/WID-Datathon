import logging
import azure.functions as func
import Data_Loading_Stage
import Data_Loading_Target

def main(mytimer: func.TimerRequest):
    if mytimer.past_due:
        logging.warning("Timer is past due!")

    logging.info("Starting Daily ETL job...")

    try:
        logging.info("Running Data Loading Stage...")
        Data_Loading_Stage.main()
        logging.info("Stage load complete")

        logging.info("Running Data Loading Target...")
        Data_Loading_Target.main()
        logging.info("Target load complete")

        logging.info("Daily ETL finished successfully")

    except Exception as e:
        logging.error(f"ETL job failed : {str(e)}", exc_info=True)
        raise

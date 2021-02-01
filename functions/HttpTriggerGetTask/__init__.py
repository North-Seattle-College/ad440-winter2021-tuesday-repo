import logging
import json

import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request to GetTask.')
    try:
        logging.info('Attempting to retrieve task...')
        taskID = req.params.get('taskID')
        task = dbHandler().getTask(taskID)
        logging.info('Sucessfully retrieved task.')
        return func.HttpResponse(json.dumps(task))
    except ExceptionWithStatusCode as err:
        logging.info('ExceptionWithStatusCode error occured while trying to retrieve task.')
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        logging.info('Exception error occured while trying to retrieve task.')
        return func.HttpResponse(str(err), status_code=500)

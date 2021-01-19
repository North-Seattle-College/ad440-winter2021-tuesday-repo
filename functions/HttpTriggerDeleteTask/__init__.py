import logging
import json

import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request. HTTPTriggerDeleteTask')
    try:
        taskID = req.params.get('taskID')
        dbHandler().deleteTask(taskID)
        return func.HttpResponse("Sucessfully deleted task")
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        return func.HttpResponse(str(err), status_code=500)
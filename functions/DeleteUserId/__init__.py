import logging

import azure.functions as func

from ..Utils.RequestHandler import RequestHandler
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function for delete user_id processed a request.')

    try:
        requestHandler = RequestHandler()
        user_id = requestHandler.deleteUserId(req)
        dbHandler = dbHandler()
        dbHandler.deleteUserId(user_id)
        return func.HttpResponse("User ID deleted", status_code=201)
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        return func.HttpResponse(str(err), status_code=500)

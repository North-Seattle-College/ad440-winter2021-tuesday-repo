import logging

import azure.functions as func

from ..Utils.RequestHandler import RequestHandler
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function for delete user_id processed a request.')

    try:
        logging.debug('Attempting a db connection...')
        requestHandler = RequestHandler()
        logging.debug('Opened connection.')
        user_id = requestHandler.deleteUserId(req)
        dbHandler = dbHandler()
        logging.debug(f'Attempting to execute DELETE user query for user {userId}')
        dbHandler.deleteUserId(user_id)
        logging.debug(f"Executed the DELETE query  for userId {userId}")
        return func.HttpResponse("User ID deleted", status_code=201)
    except ExceptionWithStatusCode as err:
        logging.error('No record with the requested parameters exists in db')
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        return func.HttpResponse(str(err), status_code=500)

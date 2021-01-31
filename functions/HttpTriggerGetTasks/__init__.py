import logging
import json
import pyodbc

import azure.functions as func
from ..Utils.dbHandler import dbHandler
from ..Utils.ExceptionWithStatusCode import ExceptionWithStatusCode


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Http trigger for /users/:userId/tasks is being initialized...')

    # connect to db
    conn_string = dbHandler().getConnString()

    try:
        id = req.params.get(':userId')

        logging.debug('Connecting to the database...')
        with pyodbc.connect(conn_string) as conn:
            logging.debug('Connected to database.')
            return getTasks(conn, id)
    except ExceptionWithStatusCode as err:
        return func.HttpResponse(str(err), status_code=err.status_code)
    except Exception as err:
        return func.HttpResponse(str(err), status_code=500)

def getTasks(conn, id):
    logging.debug('Attempting to retrieve tasks for :user')
    with conn.cursor() as cursor:
        cursor.execute(
            "SELECT taskId, title, taskDescription, completed FROM Tasks WHERE taskUserId={}".format(id)
        )
        rows = cursor.fetchall()
    for row in rows:
        columns = [column[0] for column in cursor.description]
        data = dict(zip(columns, row))

    return func.HttpResponse(
        body=data,
        status_code=200,
        mimetype='application/json'
    )
    logging.debug('Tasks retrieved')
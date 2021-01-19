import logging
import os
import pyodbc
import json
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    # Set enviro variables and establish db connection string
    SERVER = os.environ.get('SERVER')
    DATABASE = os.environ.get('DATABASE')
    USERNAME = os.environ.get('USER')
    PASSWORD = os.environ.get('PASSWORD')
    DRIVER = os.environ.get('DRIVER')
    conn_string = "Driver={};Server={};Database={};Uid={};Pwd={};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;".format(
        DRIVER, SERVER, DATABASE, USERNAME, PASSWORD)

    userId = req.params.get('id')
    if not userId:
        return func.HttpResponse(
            body="Bad Request",
            status_code=400
        )
    else:
        try:
            with pyodbc.connect(conn_string) as conn:
                return getTasks(conn, userId)
        except pyodbc.Error as err:
            sqlstate = err.args[0]
            if sqlstate == '28000':
                print("Connection failed: check password")

def getTasks(conn, userId):
    with conn.cursor() as cursor:
        cursor.execute(
            "SELECT * FROM tasks WHERE userId={}".format(userId)
        )
        rows = cursor.fetchall()
        if not row:
            return func.HttpResponse(
                body="User does not exsist",
                status_code=404
            )
        else:
            tasks = []
            for row in rows:
                tasks.append(row)

            return func.HttpResponse(
                body=tasks,
                status_code=200
            )

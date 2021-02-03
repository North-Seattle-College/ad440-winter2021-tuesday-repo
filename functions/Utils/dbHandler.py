import os
import pyodbc
from typing import List

SERVER = os.environ.get('API_SERVER')
DATABASE = os.environ.get('API_DATABASE')
USERNAME = os.environ.get('API_USER')
PASSWORD = os.environ.get('API_PASSWORD')
DRIVER = '{ODBC Driver 17 for SQL Server}'



class dbHandler():
    def getConnectionString():
        # Define the connection string
        conn_string = "Driver={};Server={}PORT=1433;Database={};Uid={};Pwd={};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;".format(
        DRIVER, SERVER, DATABASE, USERNAME, PASSWORD)

        return pyodbc.connect(conn_string)
import os
import pyodbc
from typing import List

SERVER = os.environ.get('API_SERVER')
DATABASE = os.environ.get('API_DATABASE')
USERNAME = os.environ.get('API_USERNAME')
PASSWORD = os.environ.get('API_PASSWORD')
DRIVER = '{ODBC Driver 17 for SQL Server}'



class dbHandler():
    def getConnectionString():
        # Define the connection string Driver={ODBC Driver 13 for SQL Server};Server=tcp:nsc-sqlsrv-dev-usw2-toddysm.database.windows.net,1433;Database=nsc-sqldb-dev-usw2-toddysm;Uid=sqladmin;Pwd={your_password_here};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;
        conn_string = "Driver={};Server={};Database={};Uid={};Pwd={};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;".format(
        DRIVER, SERVER, DATABASE, USERNAME, PASSWORD)

        return pyodbc.connect(conn_string)
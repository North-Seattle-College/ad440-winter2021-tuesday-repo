import os
import pyodbc
from ..Model.User import User
from ..Model.Task import Task
from typing import List

SERVER = os.environ.get('SERVER')
DATABASE = os.environ.get('DATABASE')
USERNAME = os.environ.get('USER')
PASSWORD = os.environ.get('PASSWORD')
DRIVER = os.environ.get('DRIVER')



class dbHandler():
    def getConnectionString():
    # Define the connection string
    connection_string = "Driver={};Server={};Database={};Uid={};Pwd={};Encrypt=yes;TrustServerCertificate=yes;Connection Timeout=30;".format(
        DRIVER, SERVER, DATABASE, USERNAME, PASSWORD)

    return pyodbc.connect(connection_string)
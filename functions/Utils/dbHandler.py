import os
import pyodbc
from ..Model.User import User
from ..Model.Task import Task
from typing import List
from dotenv import load_dotenv

load_dotenv()

SERVER = os.environ['SERVER']
DATABASE = os.environ['DATABASE']
USERNAME = os.environ['USER']
PASSWORD = os.environ['PASSWORD']
DRIVER = os.environ['DRIVER']

class dbHandler():
    def __init__(self):
        def __init__(self):
            self.conn_string = 'DRIVER=' + DRIVER + \
                ';SERVER=' + SERVER + \
                ';PORT=1433;DATABASE=' + DATABASE + \
                ';UID='+USERNAME+';PWD='+PASSWORD

    # [Task # 2] Query and return all user_id's from SQL DB
    def getUserIds(self) -> List[User]:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT * FROM Users")
                rows = cursor.fetchall()
        user_id = []
        for row in rows:
            user_id.append(self._rowToProduct(row))
        return user_id

    # [Task # 2] Insert new user_id into SQL DB
    def addUserId(self, user_id: User_Id) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO User_Id (id, email, userPassword, firstName, lastName, joinDate)
                    VALUES (?, ?, ?, ?, ?, ?)
                    """,
                    user_id.id, user_id.email, user_id.userPassword, user_id.firstName, user_id.lastName, user_id.joinDate
                )
                # add return messaging (user ID) back to user

    # [Task # 2] Delete user_id from SQL DB
    def deleteUserId(self, user_id: User_Id) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    DELETE FROM User_Id (id, email, userPassword, firstName, lastName, joinDate)
                    VALUES (?, ?, ?, ?, ?, ?)
                    """,
                    user_id.id, user_id.email, user_id.userPassword, user_id.firstName, user_id.lastName, user_id.joinDate
                )
                # add messaging 200 or proper exec
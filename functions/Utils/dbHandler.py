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
    def __init__(self):
        self.conn_string = "Driver={" + DRIVER + "};Server=tcp:nsc-sqlsrv-usw2-sqltest.database.windows.net,1433;Database=" + DATABASE + ";Uid=" + USERNAME + ";Pwd=" + PASSWORD + ";Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
        '''
        'Driver=' + DRIVER + \
            ';Server=' + SERVER + \
            ';PORT=1433;Database=' + DATABASE + \
            ';Uid='+USERNAME+';Pwd='+PASSWORD
            '''

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
                if response:
                    print('Successfully added user with UserId' + user_id.id)
                else:
                    print('An error has occurred.')

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
                if response:
                    print('User deleted!')
                else:
                    print('An error has occurred.')
class dbHandler():
    def __init__(self):

    # [Task # 2] Query and return all user_id's from SQL DB
    def getUserIds(self) -> List[User_Id]:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT * FROM UserID")
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
                    INSERT INTO User_Id (title, description, status, id)
                    VALUES (?, ?, ?, ?)
                    """,
                    user_id.id, user_id.firstName, user_id.lastName, user_id.email, user_id.status
                )

    # [Task # 2] Delete user_id from SQL DB
    def deleteUserId(self, user_id: User_Id) -> None:
        with pyodbc.connect(self.conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    DELETE FROM User_Id (title, description, status, id)
                    VALUES (?, ?, ?, ?)
                    """,
                    user_id.id, user_id.firstName, user_id.lastName, user_id.email, user_id.status
                )
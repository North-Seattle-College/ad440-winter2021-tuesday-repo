import React, { useState, useEffect } from "react";

import Button from "../uiElements/Button";
import DUMMY_USERS from "../data/dummy-users.json";
import { useAxiosClient } from "../hooks/axios-hook";

import "../css/UserListScreen.css";

const UsersScreen = (props) => {
  const [usersList, setUsersList] = useState([]);
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
    setUsersList(DUMMY_USERS); // TESTING ONLY
    // umcomment when endpoint is live.
    // const fetchUsers = async () => {
    //   try {
    //     const responseData = await sendRequest(
    //       `GET`,
    //       `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users`,
    //       null,
    //       { Authorization: `Bearer token` }
    //     );
    //     setUsersList(responseData.users);
    //   } catch (err) {
    //     console.log(err);
    //   }
    // };
    // fetchUsers();
  }, [sendRequest]);

  return (
    <div className="user-List">
      {usersList.map((user) => {
        return (
          <Button key={user.id} to={`users/${user.id}`}>
            {user.username}
          </Button>
        );
      })}
    </div>
  );
};

export default UsersScreen;

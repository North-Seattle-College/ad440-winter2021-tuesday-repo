import React, { useState, useEffect } from "react";

import Button from "../uiElements/Button";
import DUMMY_USERS from "../data/dummy-users.json";
import { useAxiosClient } from "../hooks/axios-hook";

import "../css/UserListScreen.css";

const UserListScreen = (props) => {
  const [usersList, setUsersList] = useState([]);
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
   // setUsersList(DUMMY_USERS); // TESTING ONLY
    // Just need the URL put in place, uncomment this
    const fetchUsers = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users`,
          null,
          { Authorization: `Bearer token` }
        );
        setUsersList(responseData.users);
      } catch (err) {
        console.log(err);
      }
    };
     fetchUsers();
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

export default UserListScreen;

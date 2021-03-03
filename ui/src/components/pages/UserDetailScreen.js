import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import Button from "../uiElements/Button";
import { useAxiosClient } from "../hooks/axios-hook";

import "../css/UserDetailScreen.css";

const UserDetailScreen = (props) => {
  const [user, setUser] = useState();
  const params = useParams();
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users/${params.userId}?`,
          null,
          null
        );
        setUser(responseData);
      } catch (err) {
        console.log(err);
      }
    };
    fetchUsers();
  }, [sendRequest, params.userId]);

  return (
    <React.Fragment>
      {user === undefined ? (
        <div>Nothing loaded!</div>
      ) : (
        <div>
          <div className="user-Header">User: {user.email}</div>
          <div className="divider" />
          <ol>
            <div className="user-description">
              First Name: {user.firstName}
              <br />
              Last Name: {user.lastName}
            </div>
          </ol>
          <div className="divider" />
          <Button className="user-Button" to={`/users/${params.userId}/tasks`}>
            View User Tasks
          </Button>
        </div>
      )}
    </React.Fragment>
  );
};

export default UserDetailScreen;

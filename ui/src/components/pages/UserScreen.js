import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import Button from "../uiElements/Button";
import DUMMY_USERS from "../data/dummy-users.json";

import "../css/UserScreen.css";

const UserScreen = (props) => {
  const [user, setUser] = useState();
  const params = useParams();

  useEffect(() => {
    DUMMY_USERS.map((item) => {
      return item.id === parseInt(params.userId) && setUser(item);
    });
  }, [params.userId, user]);

  return (
    <React.Fragment>
      {user === undefined ? (
        <div>Nothing loaded!</div>
      ) : (
        <div>
          <div className="user-Header">User: {user.id}</div>
          <div className="divider" />
          <ol>
            <div className="user-description">
              First Name: {user.first}
              <br />
              Last Name: {user.last}
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

export default UserScreen;

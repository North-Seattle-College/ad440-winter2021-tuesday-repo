import React, { useState, useEffect } from "react";

import Button from "../uiElements/Button";
import DUMMY_TESTS from "../data/dummy-tests.json";
import { useAxiosClient } from "../hooks/axios-hook";

import "../css/TestListScreen.css";

const ServerlessTests = (props) => {
  const [tests, setTestsList] = useState([]);
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
    setTestsList(DUMMY_TESTS); // TESTING ONLY
    // Just need the URL put in place, uncomment this
    // const fetchUsers = async () => {
    //   try {
    //     const responseData = await sendRequest(
    //       `GET`,
    //       `http://URLHERE/api/users`,
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
    <React.Fragment>
      Serverless Artillery Tests Taken:
      <div className="divider" />
      <div className="tests-List">
        {tests.map((test) => {
          return (
            <Button
              key={test.id}
              to={`serverless/${test.id}`}
            >
              ID: {test.id}
              <br />
              {test.date}
            </Button>
          );
        })}
      </div>
    </React.Fragment>
  );
};

export default ServerlessTests;

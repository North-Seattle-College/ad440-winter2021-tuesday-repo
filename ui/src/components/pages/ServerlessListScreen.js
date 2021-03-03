import React, { useState, useEffect } from "react";

import Button from "../uiElements/Button";
import { useAxiosClient } from "../hooks/axios-hook";

import "../css/TestListScreen.css";

const ServerlessTests = (props) => {
  const [tests, setTestsList] = useState([]);
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/artillery?`,
          null,
          null
        );
        setTestsList(responseData);
      } catch (err) {
        console.log(err);
      }
    };
    fetchUsers();
  }, [sendRequest]);

  return (
    <React.Fragment>
      Serverless Tests Taken:
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
            </Button>
          );
        })}
      </div>
    </React.Fragment>
  );
};

export default ServerlessTests;

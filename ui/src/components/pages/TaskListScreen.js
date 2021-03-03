import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import Button from "../uiElements/Button";
import { useAxiosClient } from "../hooks/axios-hook";

const TasksScreen = (props) => {
  const [tasksList, setTasksList] = useState([]);
  const { sendRequest } = useAxiosClient();
  const params = useParams();

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users/${params.userId}/tasks?`,
          null,
          null
        );
        setTasksList(responseData);
      } catch (err) {
        console.log(err);
      }
    };
    fetchUsers();
  }, [sendRequest, params.userId]);

  return (
    <React.Fragment>
      <div className="homepage-header">Tasks Found:</div>
      <div className="divider" />
      <div className="homepage-body">
        {!tasksList.length ? (
          <div>
            <br />
            No tasks exist!
          </div>
        ) : (
          tasksList.map((task) => {
            return (
              <Button
                key={task.taskId}
                to={`/users/${params.userId}/tasks/${task.taskId}`}>
                {task.title}
              </Button>
            );
          })
        )}
      </div>
    </React.Fragment>
  );
};

export default TasksScreen;

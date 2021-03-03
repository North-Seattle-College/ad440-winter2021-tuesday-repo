import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import Button from "../uiElements/Button";
import { useAxiosClient } from "../hooks/axios-hook";

import "../css/TaskListScreen.css";

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
      Tasks:
      <div className="divider" />
      <div className="task-List">
        {tasksList.map((task) => {
          return (
            <Button
              className="task-Button"
              key={task.taskId}
              to={`/users/${params.userId}/tasks/${task.taskId}`}
            >
              {task.title}
            </Button>
          );
        })}
      </div>
    </React.Fragment>
  );
};

export default TasksScreen;

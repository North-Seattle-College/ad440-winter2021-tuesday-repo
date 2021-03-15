import React, { useState, useEffect } from "react";
import { NavLink, useParams } from "react-router-dom";

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

  onDeleteHandler = (taskId) => {
    alert(`Task deleted: ${taskId}`);
    // post request out to server goes here
  };

  return (
    <React.Fragment>
      <NavLink className="button" to={`/users/${params.userId}/createtask`}>
        Create a Task
      </NavLink>
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
                className="task-Button"
                key={task.taskId}
                onDelete={onDeleteHandler}
                taskId={task.taskId}
                to={`/users/${params.userId}/tasks/${task.taskId}`}
              >
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

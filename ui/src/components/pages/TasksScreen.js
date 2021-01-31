import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import Button from "../uiElements/Button";
import DUMMY_TASKS from "../data/dummy-tasks.json";
import { useAxiosClient } from "../hooks/axios-hook";

import "../css/TaskScreen.css";

const TasksScreen = (props) => {
  const [tasksList, setTasksList] = useState([]);
  const { sendRequest } = useAxiosClient();
  const params = useParams();

  useEffect(() => {
    setTasksList(DUMMY_TASKS); // TESTING ONLY
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
    <div className="task-List">
      {tasksList.map((task) => {
        return (
          <Button
            className="task-Button"
            key={task.id}
            to={`/users/${params.userId}/tasks/${task.id}`}>
            {task.name}
          </Button>
        );
      })}
    </div>
  );
};

export default TasksScreen;

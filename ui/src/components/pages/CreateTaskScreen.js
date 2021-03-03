import React, { useState } from "react";

import { useAxiosClient } from "../hooks/axios-hook";

const CreateTaskScreen = (props) => {
  const [values, setValues] = useState({
    taskName: "",
    taskDescription: "",
    taskDueDate: "",
    taskStatus: "",
    taskOwner: "",
  });
  const { sendRequest } = useAxiosClient();

  const setHandler = (name) => {
    return ({ target: { value } }) => {
      setValues((oldValues) => ({ ...oldValues, [name]: value }));
    };
  };

  const saveFormData = async () => {
    console.log(JSON.stringify(values));
    try {
      const response = await sendRequest(
        "POST",
        "https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/tasks?",
        values,
        null
      );
      console.log(response);
    } catch (err) {
      throw new Error(`Request failed: ${err.message}`);
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    try {
      await saveFormData();
      alert("Your task has successfully been entered!");
      setValues({
        taskName: "",
        taskDescription: "",
        taskDueDate: "",
        taskStatus: "",
        taskOwner: "",
      });
    } catch (e) {
      alert(`Task creation failed! ${e.message}`);
    }
  };

  return (
    <form className="taskForm" onSubmit={handleSubmit}>
      <h2>Create a task</h2>

      <label>
        Task Name: &nbsp;
        <input
          type="text"
          required
          value={values.taskName}
          onChange={setHandler("taskName")}
        />
      </label>

      <label>
        Task Description: &nbsp;
        <input
          type="text"
          required
          value={values.taskDescription}
          onChange={setHandler("taskDescription")}
        />
      </label>

      <label>
        Task Due Date: &nbsp;
        <input
          type="text"
          required
          value={values.taskDueDate}
          onChange={setHandler("taskDueDate")}
        />
      </label>

      <label>
        Task Status: &nbsp;
        <input
          type="text"
          required
          value={values.taskStatus}
          onChange={setHandler("taskStatus")}
        />
      </label>

      <label>
        Task Owner: &nbsp;
        <input
          type="text"
          required
          value={values.taskOwner}
          onChange={setHandler("taskOwner")}
        />
      </label>

      <button variant="outline-primary" type="submit">
        Submit
      </button>
    </form>
  );
};

export default CreateTaskScreen;

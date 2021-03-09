import React, { useState } from "react";
import { useParams } from "react-router-dom";

import { useAxiosClient } from "../hooks/axios-hook";

const CreateTaskScreen = (props) => {
  const [values, setValues] = useState({
    title: "",
    description: "",
  });
  const params = useParams();
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
        `https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users/${params.userId}/tasks?`,
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
        title: "",
        description: "",
      });
    } catch (e) {
      alert(`Task creation failed! ${e.message}`);
    }
  };

  return (
    <form className="taskForm" onSubmit={handleSubmit}>
      <div className="homepage-header">Create a Task</div>
      <div className="divider" />
      <label>
        Task Name: &nbsp;
        <input
          type="text"
          required
          value={values.title}
          onChange={setHandler("title")}
        />
      </label>

      <label>
        Task Description: &nbsp;
        <input
          type="text"
          required
          value={values.description}
          onChange={setHandler("description")}
        />
      </label>

      <button variant="outline-primary" type="submit">
        Submit
      </button>
    </form>
  );
};

export default CreateTaskScreen;

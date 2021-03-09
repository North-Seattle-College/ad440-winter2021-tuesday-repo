import React, { useState } from "react";

import { useAxiosClient } from "../hooks/axios-hook";

import "../css/CreateUserScreen.css";

const CreateUserScreen = (props) => {
  const [values, setValues] = useState({
    email: "",
    userPassword: "",
    firstName: "",
    lastName: "",
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
        "https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users?",
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
      alert("Your registration was successfully submitted!");
      setValues({
        email: "",
        userPassword: "",
        firstName: "",
        lastName: "",
      });
    } catch (e) {
      alert(`Registration failed! ${e.message}`);
    }
  };

  return (
    <form className="userForm" onSubmit={handleSubmit}>
      <h2>Register</h2>

      <label>
        First Name *:
        <input
          type="text"
          required
          value={values.firstName}
          onChange={setHandler("firstName")}
        />
      </label>

      <label>
        Last Name *:
        <input
          type="text"
          required
          value={values.lastName}
          onChange={setHandler("lastName")}
        />
      </label>

      <label>
        Email *:
        <input
          type="email"
          required
          value={values.email}
          onChange={setHandler("email")}
        />
      </label>

      <label>
        Password *:
        <input
          type="password"
          required
          min="6"
          value={values.userPassword}
          onChange={setHandler("userPassword")}
        />
      </label>

      <button variant="outline-primary" type="submit">
        Submit
      </button>
    </form>
  );
};

export default CreateUserScreen;

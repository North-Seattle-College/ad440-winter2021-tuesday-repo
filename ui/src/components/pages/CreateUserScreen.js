import React, { useState, useEffect } from "react";
// import express from 'express';

const url = "https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users";
const config = {
    url,
    headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
    }
}

const CreateUserScreen = (props) => {
    const [firstname, setFirstName] = useState();
    const [lastname, setLastName] = useState();
    const [email, setEmail] = useState();
    const queryString = require('query-string');

    const handleSubmit = (event) => {
        console.log(`
        FirstName: ${firstname}
        LastName: ${lastname}
        Email: ${email}
        `);
        fetch("https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users", {
            method: "POST",
            headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                firstname,
                lastname,
                email

            })
        })
        event.preventDefault();
    }

    return (
        <form onSubmit={handleSubmit}>
            <h1>Create a User</h1>

            <label>
                First Name:
            <input
                    name="firstname"
                    type="firstname"
                    value={firstname}
                    onChange={e => setFirstName(e.target.value)}
                    required />
            </label>

            <label>
                Last Name:
            <input
                    name="lastname"
                    type="lastname"
                    value={lastname}
                    onChange={e => setLastName(e.target.value)}
                    required />
            </label>
            <label>
                Email:
            <input
                    name="email"
                    type="email"
                    value={email}
                    onChange={e => setEmail(e.target.value)}
                    required />
            </label>
            <button>Submit</button>
        </form>
    );
};

export default CreateUserScreen;
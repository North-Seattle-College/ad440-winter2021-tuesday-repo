import React, { useState, useEffect } from "react";
// import express from 'express';

// const app = express();
// app.use((req, res, next) => {
//   res.setHeader('Access-Control-Allow-Origin', '*');
//   res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type,Accept, Authortization');
//   res.setHeader('Acces-Control-Allow-Methods', 'GET, POST, PATCH, DELETE');
// });

const CreateUserScreen = (props) => {
    const [firstname, setFirstName] = useState();
    const [lastname, setLastName] = useState();
    const queryString = require('query-string');
    
    const handleSubmit = (event) => {
        console.log(`
        FirstName: ${firstname}
        LastName: ${lastname}
        `);
        fetch("https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users", {
            method: "POST",
            body: queryString.stringify({
                setFirstName,
                setLastName
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
            <button>Submit</button>
        </form>
    );
};

export default CreateUserScreen;
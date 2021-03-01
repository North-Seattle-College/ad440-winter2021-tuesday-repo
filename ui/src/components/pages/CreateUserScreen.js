import React, { useState, useEffect } from "react";

const CreateUserScreen = (props) => {
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [email, setEmail] = useState('');
    const [userPassword, setUserPassword] = useState('');

    const handleSubmit = (event) => {
        console.log(`
        FirstName: ${firstName}
        LastName: ${lastName}
        Email: ${email}
        UserPassword: ${userPassword}
        `);
        fetch("https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users", {
            method: "POST",
            headers: {
                'Access-Control-Allow-Origin': 'http://localhost:3000',
                'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                email,
                userPassword,
                firstName,
                lastName
            })
            }).then((response) => {
                if (response.status === 200 || response.status === 201) { // Can also use created user response userId instead
                    alert('it works! ');
                } 
                else {
                    alert("Fail to create a new user");
                }
        })
    }

    return (
        <form onSubmit={handleSubmit}>
            <h1>Create a User</h1>

            <label>
                First Name:
            <input
                    name="firstName"
                    type="firstName"
                    value={firstName}
                    onChange={e => setFirstName(e.target.value)}
                    required />
            </label>

            <label>
                Last Name:
            <input
                    name="lastName"
                    type="lastName"
                    value={lastName}
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
            <label>
                Password:
            <input
                    name="userPassword"
                    type="userPassword"
                    value={userPassword}
                    onChange={e => setUserPassword(e.target.value)}
                    required />
            </label>
            <button>Submit</button>
        </form>
    );
};

export default CreateUserScreen;
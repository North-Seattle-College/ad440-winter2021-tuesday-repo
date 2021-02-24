import React, { useState, useEffect } from "react";

const CreateUserScreen = (props) => {
    const [firstName, setFirstName] = useState();
    const [lastName, setLastName] = useState();
    const [email, setEmail] = useState();
    const [userPassword, setUserPassword] = useState();
    const [userId, setUserId] = useState();

    const generateId = () => {
        return Math.floor(Math.random() * 10000); //0 to 9999
    }

    const handleSubmit = (event) => {
        console.log(`
        UserId: ${userId}
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
                userId,
                email,
                userPassword,
                firstName,
                lastName,    
            }),
            mode: "no-cors"
        })
        event.preventDefault();
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
                    onChange={e => { setUserPassword(e.target.value); setUserId(generateId)} }
                    required />
            </label>
            <button>Submit</button>
        </form>
    );
};

export default CreateUserScreen;
import React, { useState } from "react";
import '../css/CreateUserScreen.css';

function CreateUserScreen() {
    const [values, setValues] = useState({
        email: '', userPassword: '', firstName: '', lastName: ''
    });

    const onChange = (event) => {
        setValues(event.target.value);
    };

    const set = name => {
        return ({ target: { value } }) => {
            setValues(oldValues => ({ ...oldValues, [name]: value }));
        }
    };

    const saveFormData = async () => {
        console.log(JSON.stringify(values));
        const response = await fetch('https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/users', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(values)
        });
        if (response.status !== 200 || response.status !== 204) {
            throw new Error(`Request failed: ${response.status}`);
        }
    }

    const handleSubmit = async (event) => {
        event.preventDefault();
        try {
            await saveFormData();
            alert('Your registration was successfully submitted!');
            setValues({
                email: '', userPassword: '', firstName: '', lastName: ''
            });
        } catch (e) {
            alert(`Registration failed! ${e.message}`);
        }
    }

    return (
        <form className="userForm" onSubmit={handleSubmit}>
            <h2>Register</h2>

            <label>First Name *:
            <input
                    type="text" required
                    value={values.firstName} onChange={set('firstName')}
                />
            </label>

            <label>Last Name *:
            <input
                    type="text" required
                    value={values.lastName} onChange={set('lastName')}
                />
            </label>

            <label>Email *:
            <input
                    type="email" required
                    value={values.email} onChange={set('email')}
                />
            </label>

            <label>Password *:
            <input
                    type="password" required min="6"
                    value={values.userPassword} onChange={set('userPassword')}
                />
            </label>

            <button variant="outline-primary" type="submit">Submit</button>
        </form>
    );
}

export default CreateUserScreen;


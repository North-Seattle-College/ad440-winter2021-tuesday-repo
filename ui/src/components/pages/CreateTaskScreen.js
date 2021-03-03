import React, { useState } from "react";
import '../css/CreateTaskScreen.css';

function CreateTaskScreen() {
    const [values, setValues] = useState({
        taskName: '', taskDescription: '', taskDueDate: '', taskStatus: '', taskOwner: ''
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
        const response = await fetch('https://nsc-func-dev-usw2-tuesday.azurewebsites.net/api/tasks', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(values)
        });
        if (response.status !== 200) {
            throw new Error(`Request failed: ${response.status}`);
        }
    }

    const handleSubmit = async (event) => {
        event.preventDefault();
        try {
            await saveFormData();
            alert('Your task has successfully been entered!');
            setValues({
                taskName: '', taskDescription: '', taskDueDate: '', taskStatus: '', taskOwner: ''
            });
        } catch (e) {
            alert(`Task creation failed! ${e.message}`);
        }
    }

    return (
        <form className="taskForm" onSubmit={handleSubmit}>
            <h2>Create a task</h2>

            <label>Task Name: &nbsp;
            <input
                    type="text" required
                    value={values.taskName} onChange={set('taskName')}
                />
            </label>

            <label>Task Description: &nbsp;
            <input
                    type="text" required
                    value={values.taskDescription} onChange={set('taskDescription')}
                />
            </label>

            <label>Task Due Date: &nbsp;
            <input
                    type="text" required
                    value={values.taskDueDate} onChange={set('taskDueDate')}
                />
            </label>

            <label>Task Status: &nbsp;
            <input
                    type="text" required
                    value={values.taskStatus} onChange={set('taskStatus')}
                />
            </label>

            <label>Task Owner: &nbsp;
            <input
                    type="text" required
                    value={values.taskOwner} onChange={set('taskOwner')}
                />
            </label>

            <button variant="outline-primary" type="submit">Submit</button>
        </form>
    );
}

export default CreateTaskScreen;
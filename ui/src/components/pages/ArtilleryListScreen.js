import React, { useState, useEffect } from "react";
import Button from '../uiElements/Button';
import DUMMY_TESTS from "../data/dummy-tests.json";
import { useAxiosClient } from "../hooks/axios-hook";
import "../css/HomeScreen.css";

const ArtilleryListScreen = (props) => {
  const [scriptList, setScriptList] = useState([])
  const { sendRequest } = useAxiosClient();

  useEffect(() => {
    setScriptList(DUMMY_TESTS); // TESTING ONLY
    // Just need the URL put in place, uncomment this
    const fetchTestScripts = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `/api/HttpTriggerLoadTest`,
          null,
          { Authorization: `Bearer token` }
        );
        setScriptList(responseData.users);
      } catch (err) {
        console.log(err);
      }
    };
    fetchTestScripts();
  }, [sendRequest]);

  function clickHandler() {
    console.log("I'm a fuç#ing button.")
  }

  return (
    <React.Fragment>
      <section>
        <div className="homepage-header">No Script Loaded!</div>
        <div className="divider" />
        <div className="homepage-body">Select a script to begin.
          {scriptList.map((script) => {
            return (
              <Button
                className="task-Button"
                key={script.id}
                onClick={clickHandler}
              >
                {script.name}
              </Button>
            );
           })}
        </div>
      </section>
    </React.Fragment>
  );
};

export default ArtilleryListScreen;

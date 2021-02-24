import React, { useState, useEffect } from "react";

// External React components;
import Button from '../uiElements/Button';

// Dummy data imports;
import DUMMY_TESTS from "../data/dummy-tests.json";

// Hook imports;
import { useAxiosClient } from "../hooks/axios-hook";

// Stylesheets;
import "../css/HomeScreen.css";

// TODO: install Azure JavaScript SDK for Azure Storage and connect to common resource group (Azure);
// TODO: GET dynamic number of Artillery reports from Storage (Blob Client);
// TODO: render these Buttons;
// TODO: make each Button, when clicked, render data associated with Artillery report by id;

// Begin: React component;
const ArtilleryListScreen = (props) => {
  const [scriptList, setScriptList] = useState([])
  const { sendRequest } = useAxiosClient();

  // Upon loading, renders a Button for each report found in Storage;
  useEffect(() => {
    // setScriptList(DUMMY_TESTS); // TESTING ONLY
    // Just need the URL put in place, uncomment this
    const fetchTestScripts = async () => {
      try {
        const responseData = await sendRequest(
          `GET`,
          `.github/workflows/artillery-action-users-id-tasks-api.yml`,
          null,
          { Authorization: `Bearer token` }
        );
        setScriptList(responseData.results);
      } catch (err) {
        console.log(err);
      }
    };
    fetchTestScripts();
  }, [sendRequest]);

  // TODO: make this function access the particular report mapped to the
  // corresponding React Button and render using ArtilleryDetailScreen;
  function clickHandler() {
    console.log("I'm a button.");
  }

  return (
    <React.Fragment>
      <section>
        <div className="homepage-body">
          Select a script to begin.
          <br />
          {scriptList.map((script) => {
            return (
              <Button
                key={script.id}
                onClick={clickHandler}
                // This will map to individual report (i.e. ArtilleryDetailScreen component);
                to={`/artillery/${script.id}`}
              >
                Artillery Test Details, Test #{script.id}
                {script.name}
              </Button>
            );
          })}
        </div>
      </section>
    </React.Fragment>
  );
};
// End React component;

export default ArtilleryListScreen;

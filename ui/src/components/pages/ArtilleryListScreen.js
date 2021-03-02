import React, { useState, useEffect } from "react";
import { AnonymousCredential, BlobServiceClient } from "@azure/storage-blob";
// External React components;
import Button from '../uiElements/Button';

// Hook imports;
import { useAxiosClient } from "../hooks/axios-hook";

// Stylesheets;
import "../css/HomeScreen.css";

// Load the .env file if it exists
require("dotenv").config();

// Azure Blob Storage SDK imports;
// const account = process.env.CLIENT_ID;
const anonymousCredential = new AnonymousCredential();
const containerName = "Artillery";

// TODO: install Azure JavaScript SDK for Azure Storage and connect to common resource group (Azure); DONE
// TODO: GET dynamic number of Artillery reports from Storage (Blob Client);
// TODO: render these Buttons;
// TODO: make each Button, when clicked, render data associated with Artillery report by id;

// Begin: React component;
const ArtilleryListScreen = () => {
  const [reportList, setReportList] = useState([])
  const { sendRequest } = useAxiosClient();


  // Upon loading, renders a Button for each report found in Storage;
  useEffect(() => {
    // setScriptList(DUMMY_TESTS); // TESTING ONLY
    // Just need the URL put in place, uncomment this
    // List containers
    const blobServiceClient = new BlobServiceClient(
      // When using AnonymousCredential, following url should include a valid SAS or support public access
      `https://nscstrdevusw2tuecommon.blob.core.windows.net`,
      anonymousCredential
    );

    const fetchArtilleryReports = async () => {
      // Get container client as object;
      const containerClient = blobServiceClient.getContainerClient(containerName);
      try {
        console.log("Listing blobs: ");
        // List blobs
        let i = 1;
        const blobs = containerClient.listBlobsFlat();
        for await (const blob of blobs) {
          console.log(`Blob ${i++}: ${blob.name}`);
        }
        setReportList(blobs);
      } catch (err) {
        console.log(err);
      }
    }
      fetchArtilleryReports();
    }, []);



  // TODO: make this function access the particular report mapped to the
  // corresponding React Button and render it using ArtilleryDetailScreen;
  // Update: I think this may be unnecessary, as we have the 'to' set on Button below;
  function clickHandler() {
    console.log("I'm a button.");
  }

  return (
    <React.Fragment>
      <section>
        <div className="homepage-body">
          <b>Select a log to read: </b>
          <br />
          {reportList.map((report) => {
            return (
              <Button
                key={report.id}
                onClick={clickHandler}
                // This will map to individual report (i.e. ArtilleryDetailScreen component);
                // This relationship is defined in App.js;
                to={`/artillery/:${report.id}`}
              >
                Artillery Test Details, Test #{report.id}
                {report.name}
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

import React, { useState, useEffect } from "react";

// For handling Azure blob/container resources;
import { AnonymousCredential, BlobServiceClient } from "@azure/storage-blob";

// External React components;
import Button from '../uiElements/Button';

// Hook imports;
// import { useAxiosClient } from "../hooks/axios-hook";

// Stylesheets;
import "../css/HomeScreen.css";

// Load the .env file if it exists
require("dotenv").config();

// Azure Blob Storage SDK imports;
// const account = process.env.CLIENT_ID;
const anonymousCredential = new AnonymousCredential();
const containerName = "artillery";

// TODO: install Azure JavaScript SDK for Azure Storage and connect to common resource group (Azure); DONE
// TODO: GET dynamic number of Artillery reports from Storage (Blob Client); DONE
// TODO: render these Buttons;
// TODO: make each Button, when clicked, render data associated with Artillery report by id;

// Begin: React component;
const ArtilleryListScreen = () => {
  const [reportList, setReportList] = useState([])
  // const { sendRequest } = useAxiosClient();


  // Upon loading, renders a Button for each report found in Storage;
  useEffect(() => {
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
        let reports = [];
        for await (const blob of blobs) {
          console.log(`Blob ${i++}: ${blob.name}`);
          reports.push(blob);
        }
        setReportList(reports);
      } catch (err) {
        console.log(err);
      }
    }
      fetchArtilleryReports();
    }, []);

  return (
    <React.Fragment>
      <section>
        <div className="homepage-body">
          <b>Select a log to read: </b>
          <br />
          {reportList.map((report) => {
            return (
              <Button
                key={report.name}
                // This will map to individual report (i.e. ArtilleryDetailScreen component);
                // This relationship is defined in App.js;
                to={`/artillery/:${report.name}`}
              >
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

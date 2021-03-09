import React, { useState, useEffect } from "react";

// For handling Azure blob/container resources;
// install Azure JavaScript SDK for Azure Storage and connect to
// common resource group(Azure);
import { AnonymousCredential, BlobServiceClient } from "@azure/storage-blob";

// External React components;
import Button from "../uiElements/Button";

// Azure Blob-Storage SDK;
const anonymousCredential = new AnonymousCredential();
const containerName = "artillery";

// Begin: React Component;
const ArtilleryListScreen = () => {
  const [reportList, setReportList] = useState([]);

  // Upon loading, renders a Button for each report(Blob) found in Storage;
  useEffect(() => {
    const blobServiceClient = new BlobServiceClient(
      // When using AnonymousCredential, following url should include a valid SAS or support public access
      `https://nscstrdevusw2tuecommon.blob.core.windows.net`,
      anonymousCredential
    );

    const fetchArtilleryReports = async () => {
      // Get container client as object instance;
      const containerClient = blobServiceClient.getContainerClient(
        containerName
      );

      try {
        console.log("Listing blobs: ");
        // List blobs
        let i = 1;
        const blobs = containerClient.listBlobsFlat();

        // Reports is JS array of blobs;
        let reports = [];

        for await (const blob of blobs) {
          console.log(`Blob ${i++}: ${blob.name}`);
          reports.push(blob);
        }
        setReportList(reports);
      } catch (err) {
        console.log(err);
      }
    };
    fetchArtilleryReports();
  }, []);

  return (
    <React.Fragment>
      <section>
        <div className="homepage-body">
          <b>Select a log to read: </b>
          <br />
          {!reportList.length ? (
            <div>
              <br />
              No logs exist!
            </div>
          ) : (
            reportList.map((report) => {
              return (
                <Button
                  key={report.name}
                  // TODO: make this route to a working ArtilleryDetailScreen;
                  // This screen shall display the contents of the report;
                  to={`/artillery/:${report.name}`}>
                  {report.name}
                </Button>
              );
            })
          )}
        </div>
      </section>
    </React.Fragment>
  );
};
// End React Component;

export default ArtilleryListScreen;

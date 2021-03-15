import React, { useState, useEffect } from "react";
import { AnonymousCredential, BlobServiceClient } from "@azure/storage-blob";

import Button from "../uiElements/Button";

const ServerlessListScreen = () => {
  const [reportList, setReportList] = useState([]);

  // Grabs the serverless blobs. TODO: Merge with Artillery
  useEffect(() => {
    const containerName = "serverless-artillery";
    const anonymousCredential = new AnonymousCredential();
    const blobServiceClient = new BlobServiceClient(
      `https://nscstrdevusw2tuecommon.blob.core.windows.net`,
      anonymousCredential
    );
    const fetchArtilleryReports = async () => {
      const containerClient = blobServiceClient.getContainerClient(
        containerName
      );
      try {
        const blobs = containerClient.listBlobsFlat();
        let reports = [];
        for await (const blob of blobs) {
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
                  to={`/serverless-artillery/:${report.name}`}>
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

export default ServerlessListScreen;

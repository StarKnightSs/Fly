//
// Download.js
// Created by Arpit Williams on 13/05/24.
// Copyright (c) 2024 StarKnights Technologies

async function downloadFile(filename) {
  if (filename.length < 1) {
    console.log("Invalid Filename");
    return;
  }
  lastMegaBytes = 0;
  start = new Date();
  lastNow = new Date().getTime();

  var request = createRequest();
  request.responseType = "blob";
  request.addEventListener("load", (e) => {
    if (request.status == 200) {
      downloadBlob(request.response, filename);
    } else {
      handleLoadError(e);
    }
  });

  const path = "/" + filename;
  request.open("get", path);
  request.send();
}

function downloadBlob(blob, filename) {
  blob = new Blob([blob], { type: "application/octet-stream" });
  const blobUrl = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = blobUrl;
  link.download = filename;
  document.body.appendChild(link);
  let event = new MouseEvent("click", { bubbles: true, cancelable: true, view: window });
  link.dispatchEvent(event);
  document.body.removeChild(link);
}

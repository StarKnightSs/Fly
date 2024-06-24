//
// Upload.js
// Created by Arpit Williams on 13/05/24.
// Copyright (c) 2024 StarKnights Technologies

function openFileInput() {
  document.getElementById("input").click();
}

async function uploadFile() {
  const file = document.getElementById("input").files[0];
  if (file == undefined) {
    console.log("No file selected");
    return;
  }

  lastMegaBytes = 0;
  start = new Date();
  lastNow = new Date().getTime();

  const fileName = file.name;
  const fileSize = file.size;
  const path = "/" + fileName + "/" + fileSize;

  var request = createRequest();
  request.open("post", path, true);
  request.send(file);

  document.getElementById("input").value = "";
}

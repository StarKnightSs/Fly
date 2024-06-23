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

  showProgress(true);
  updateStatusMessage("Uploading...");

  const fileName = file.name;
  const fileSize = file.size;
  const path = "/" + fileName + "/" + fileSize;

  var request = new XMLHttpRequest();
  var lastNow = new Date().getTime();
  var lastMegaBytes = 0;

  request.upload.addEventListener("progress", function (e) {
    var now = new Date().getTime();
    var bytes = e.loaded;
    var total = e.total;
    var percent = (bytes / total) * 100;
    var megaBytes = bytes / (1024 * 1024);
    var totalMegaBytes = total / (1024 * 1024);
    var elapsedTime = (now - lastNow) / 1000;
    var lastUploadedMBytes = megaBytes - lastMegaBytes;
    let remainingMegaBytes = (e.total - e.loaded) / (1024 * 1024);
    var speed = elapsedTime ? lastUploadedMBytes / elapsedTime : 0;
    let time = remainingMegaBytes / speed;
    lastMegaBytes = megaBytes;
    lastNow = now;
    updateProgress(percent, speed, time);
    updateStatusMessage("Uploaded " + megaBytes.toFixed(2) + " MB of " + totalMegaBytes.toFixed(2) +" MB");
  });

  var start = new Date();
  request.addEventListener("loadend", () => {
    var end = new Date();
    var seconds = (end.getTime() - start.getTime()) / 1000;
    showProgress(false);
    updateProgress(0,0,0);
    updateStatusMessage("Transferred in " + format(seconds));
    document.getElementById("input").value = "";
  });

  request.open("post", path);
  request.send(file);
}

function updateStatusMessage(text) {
  var statusMessage = document.getElementById("statusMessage");
  statusMessage.hidden = false;
  statusMessage.innerHTML = text;
}

function showProgress(value) {
  var info = "";
  var note = "";
  if (value == true) {
    info = "DATA IN TRANSIT 🚀";
    note = "Note: Please don't close this window during file transfer.";
  } else {
    info = "Tap the button above to send file to the Fly App 👆";
    note = "Tip: To send multiple files, ZIP them up.";
  }
  document.getElementById("info").innerHTML = info;
  document.getElementById("note").innerHTML = note;
  document.getElementById("progress").hidden = value == false;
  document.getElementById("upload").disabled = value == true;
}

function updateProgress(percent, speed, time) {
  document.getElementById("speed").innerHTML = "Speed: " + speed.toFixed(2) + " Mb/s";
  document.getElementById("time").innerHTML = "Time: " + format(time);
  document.getElementById("progress-bar").style.width = percent.toFixed(2) + "%";
  document.getElementById("progress-bar").innerHTML = percent.toFixed(2) + " %";
}

function format(seconds) {
  var suffix = "";
  var seconds = seconds;
  if (0 <= seconds < 60) {
    suffix = seconds > 1 ? "secs" : "sec";
  } else if (60 <= seconds < 3600) {
    seconds /= 60;
    suffix = seconds > 1 ? "mins" : "min";
  } else {
    seconds /= 3600;
    suffix = seconds > 1 ? "hrs" : "hr";
  }
  return seconds.toFixed(2) + " " + suffix;
}

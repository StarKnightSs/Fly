//
// Common.js
// Created by Arpit Williams on 13/05/24.
// Copyright (c) 2024 StarKnights Technologies

var lastInfo = "";
var lastNote = "";

var fileSizeInMb = 0;
var lastMegaBytes = 0;

var start = new Date();
var lastNow = new Date().getTime();

function createRequest() {
  var request = new XMLHttpRequest();
  request.addEventListener("load", handleLoadEnd);
  request.addEventListener("error", handleLoadError);
  request.addEventListener("loadstart", handleLoadStart);
  request.addEventListener("progress", handleLoadProgress);
  request.upload.addEventListener("progress", handleLoadProgress);
  return request;
}

function handleLoadProgress(e) {
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
  if (fileSizeInMb < totalMegaBytes) {
    fileSizeInMb = totalMegaBytes;
  }
  updateProgress(percent, speed, time);
  let message = "Transferred ".concat(megaBytes.toFixed(2)," MB of ", fileSizeInMb.toFixed(2)," MB");
  updateStatusMessage(message);
}

function handleLoadStart(e) {
  showProgress(true);
  updateInfoMessage(true);
  updateStatusMessage("Launching...");
}

function handleLoadError(e) {
  showProgress(false);
  updateProgress(0, 0, 0);
  updateInfoMessage(false);
  updateStatusMessage("🔺 File Transfer Error 🔺");
  document.getElementById("button").disabled = true;
  document.getElementById("info").innerHTML = "Please resend link from Fly App";
  document.getElementById("note").innerHTML = "Error: Unable to process this request.";
}

function handleLoadEnd(e) {
  var end = new Date();
  var seconds = (end.getTime() - start.getTime()) / 1000;
  showProgress(false);
  updateProgress(0, 0, 0);
  updateInfoMessage(false);
  let message = "Transferred ".concat(fileSizeInMb.toFixed(2), " MB in ", format(seconds))
  updateStatusMessage(message);
}

function updateStatusMessage(text) {
  var statusMessage = document.getElementById("statusMessage");
  statusMessage.hidden = false;
  statusMessage.innerHTML = text;
}

function showProgress(value) {
  document.getElementById("progress").hidden = value == false;
  document.getElementById("button").disabled = value == true;
}

function updateProgress(percent, speed, time) {
  document.getElementById("speed").innerHTML =
  "Speed: " + speed.toFixed(2) + " Mb/s";
  document.getElementById("time").innerHTML = "Time: " + format(time);
  document.getElementById("progress-bar").style.width =
  percent.toFixed(2) + "%";
  document.getElementById("progress-bar").innerHTML = percent.toFixed(2) + " %";
}

function updateInfoMessage(inProgress) {
  var info = "";
  var note = "";
  if (inProgress == true) {
    info = "DATA IN TRANSIT 🚀";
    note = "Note: Please don't close this window during file transfer.";
    lastInfo = document.getElementById("info").innerHTML;
    lastNote = document.getElementById("note").innerHTML;
  } else {
    info = lastInfo;
    note = lastNote;
  }
  document.getElementById("info").innerHTML = info;
  document.getElementById("note").innerHTML = note;
}

function format(seconds) {
  var suffix = "";
  var seconds = seconds;
  if (seconds >= 0 && seconds < 60) {
    suffix = seconds > 1 ? "secs" : "sec";
  } else if (seconds >= 60 && seconds < 3600) {
    seconds /= 60;
    suffix = seconds > 1 ? "mins" : "min";
  } else {
    seconds /= 3600;
    suffix = seconds > 1 ? "hrs" : "hr";
  }
  return seconds.toFixed(2) + " " + suffix;
}

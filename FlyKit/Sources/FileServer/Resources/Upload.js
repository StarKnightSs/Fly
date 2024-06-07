//
//  Upload.js
//  PocketCloud (iOS)
//
//  Created by Arpit Williams on 13/05/24.
//

const form = document.querySelector('form');
form.addEventListener('submit', handleSubmit);

const progressBar = document.querySelector('progress');
const statusMessage = document.getElementById('statusMessage');


const lastTime = localStorage.getItem("lastTime");
if (lastTime != undefined) {
  updateStatusMessage("Last Upload completed in " + lastTime);
}


async function handleSubmit(event) {
  event.preventDefault();
  const file = document.getElementById("input").files[0];
  if (file == undefined) {
    console.log("No file selected");
    return;
  }

  const fileName = file.name;
  const fileSize = file.size;
  const path = "/" + fileName + "/" + fileSize;
  var request = new XMLHttpRequest();

  var lastNow = new Date().getTime();
  var lastKBytes = 0;

  updateStatusMessage('⏳ Pending...')
  request.upload.addEventListener('progress', function (e) {
    const progress = (e.loaded / e.total);
    updateProgressBar(progress);
    var now = new Date().getTime();
    var bytes = e.loaded;
    var total = e.total;
    var percent = bytes / total * 100;
    var kbytes = bytes / 1024;
    var mbytes = kbytes / 1024;
    var uploadedkBytes = kbytes - lastKBytes;
    var elapsed = (now - lastNow) / 1000;
    var kbps =  elapsed ? uploadedkBytes / elapsed : 0 ;
    var lastMBytes = lastKBytes / 1024;
    var uploadedMBytes = mbytes - lastMBytes;
    var mbps =  elapsed ? uploadedMBytes / elapsed : 0 ;
    lastKBytes = kbytes;
    lastNow = now;
    updateStatusMessage("Uploaded " + mbytes.toFixed(2) + "MB (" + percent.toFixed(2) + "%) " + kbps.toFixed(2) + "KB/s" + " | " + mbps.toFixed(2) + "MB/s");
  });

  var start = new Date()
  request.addEventListener('loadend', () => {
    var end = new Date();
    const time = timeDiff(start, end);
    localStorage.setItem("lastTime", time);
    updateStatusMessage("Uploaded in " + time);
    window.location.reload();
  });

  request.open('post', path);
  request.send(file);
}

function updateStatusMessage(text) {
  statusMessage.textContent = text;
}

function updateProgressBar(value) {
  const percent = value * 100;
  progressBar.value = Math.round(percent);
}

function formatBytes(bytes, decimals = 2) {
  if (!+bytes) return '0 Bytes'
  const k = 1024
  const dm = decimals < 0 ? 0 : decimals
  const sizes = ['Bytes', 'KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`
}

function timeDiff(start, end) {
  var diff = (end.getTime() - start.getTime()) / 1000;
  if (diff < 60) {
    return diff + " seconds"
  } else {
    diff /= 60;
    return diff.toFixed(2) + " minutes"
  }
}

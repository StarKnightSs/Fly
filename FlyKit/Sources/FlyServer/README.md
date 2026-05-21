# FlyServer

`FlyServer` is the server and filesystem backend for Fly. It hosts the local Vapor
application, serves the file-transfer web experience, and performs all filesystem work
needed by the app.

## Responsibilities

- start and configure the local HTTP server
- render the upload, download, and file browser pages
- stream files efficiently to and from the device
- update the app when files are added, removed, or renamed
- gather file metadata for the UI
- copy, move, rename, remove, and enumerate files and folders
- create ZIP archives for sharing selected files
- manage app configuration retrieved from the backend service
- support dependency registration through Resolver

## Main types

- `FileServer` — owns the Vapor application and starts the local server
- `FileController` — declares routes for browse, upload, download, delete, and archive
- `FilesManager` — file-system operations, metadata extraction, and directory management
- `ZipManager` — creates ZIP archives for selected files
- `AppConfigManager` — fetches server-driven app configuration
- `AudioManager` — sound cues used during transfer operations
- `ProgressManager` — central transfer progress state
- `Register.swift` — Resolver registration for the module’s services

## Route overview

The local server exposes routes for:

- `GET /` — file browser
- `GET /upload` — upload page
- `GET /download/:filename` — download page
- `GET /:filename` — file download
- `GET /archive.zip` — download the generated archive
- `GET /delete/:filename` — delete a file
- `POST /:filename/:filesize` — upload a file stream

## File handling

`FilesManager` is the main filesystem abstraction. It:

- resolves the documents and temporary directories
- builds file models for the UI
- tracks the current directory
- enforces copy/move/rename validation
- excludes transferred items from backup where appropriate
- exposes a broad set of supported file types through `UTType`

## Notes

- The server uses Vapor and Leaf for HTTP handling and HTML rendering.
- Upload and download streams update shared progress state in real time.
- ZIP archives are created in the temporary directory.

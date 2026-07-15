# ADR 0005: MinIO Access Model

## Status
Accepted

## Context
We need to serve product images to the frontend and allow admins to upload images securely. Making the bucket entirely public simplifies frontend delivery but opens the risk of unauthenticated uploads or scraping. Making it entirely private requires the backend to proxy every image request or generate presigned URLs for every image load, which degrades performance and increases backend load.

## Decision
We will use a hybrid approach. The `socduacl-public` bucket will have a public-read policy (`s3:GetObject`) allowing the frontend to load images directly via static URLs. However, uploads and deletions require authentication. Admins will request a presigned upload URL from the backend, upload the file directly to MinIO, and then confirm the upload with the backend.

## Consequences
- **Positive**: High performance for image serving. Offloads upload bandwidth from the backend.
- **Negative**: Requires handling presigned URL generation and a two-step upload confirmation process in the UI.

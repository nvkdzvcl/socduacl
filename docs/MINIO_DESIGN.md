# Socduacl - MinIO Design

MinIO is used as an S3-compatible object storage solution for media assets.

## 1. Buckets & Access Policy
- **`socduacl-public`**: Stores publicly accessible assets (product images, banners).
  - **Access Policy**: Public-Read (`s3:GetObject` allowed for `*`).
  - *Justification*: Product images must be served rapidly to customers globally. Requiring presigned URLs for every product image load on the frontend would cripple performance and drastically increase backend load. Uploads and deletions remain private.

## 2. Object Key Conventions
- **Products**: `products/{productId}/{uuid}_{originalFileName}`
- **Brands**: `brands/{brandId}/{uuid}_{originalFileName}`
- **Banners**: `banners/{uuid}_{originalFileName}`
- *Example*: `products/550e8400-e29b-41d4-a716-446655440000/a1b2c3d4_front.jpg`

## 3. Upload Workflow (Presigned URLs)
1. Admin requests upload: `POST /api/v1/admin/media/presigned-url` with `{filename: "front.jpg", contentType: "image/jpeg"}`.
2. Backend validates auth and generates a **Presigned PUT URL** valid for **5 minutes**.
3. Backend returns the `uploadUrl` and the expected `objectKey`.
4. Admin frontend uploads the file directly to MinIO using the presigned URL.
5. Admin frontend confirms the upload: `POST /api/v1/admin/products/{id}/images` with `{objectKey: "..."}`.
6. Backend verifies the object exists in MinIO (optional, via stat) and saves the metadata to `catalog_product_images`.

## 4. Constraints & Security
- **Supported Content Types**: `image/jpeg`, `image/png`, `image/webp`.
- **Maximum File Size**: 5MB per image. Enforced by MinIO presigned URL conditions.
- **Security Validation**: The backend must ensure the requested `contentType` is an image before generating the URL.

## 5. Maintenance
- **Image Deletion**: When an Admin deletes an image from the catalog via the API, the backend deletes the record from PostgreSQL and issues a `DeleteObject` command to MinIO.
- **Orphan Object Cleanup**: A background cron job (or script) should periodically compare `catalog_product_images.minio_object_key` against MinIO objects to remove orphaned images (uploaded via presigned URL but never confirmed to the DB).
- **Development Bootstrap**: The `docker-compose.yml` should include a `minio-setup` container (using the `mc` CLI tool) to automatically create the `socduacl-public` bucket and set the public policy on startup.

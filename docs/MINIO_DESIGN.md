# Socduacl - MinIO Design

MinIO is used as an S3-compatible object storage solution for media assets.

## 1. Buckets
- **`socduacl-public`**: Stores publicly accessible assets (e.g., product images, brand logos, banners).
- **`socduacl-private`**: (Optional for MVP) Stores private assets like invoice PDFs or admin-only exports.

## 2. Object Naming Conventions
To prevent collisions and maintain organization, object keys should follow a structured path:
- **Products**: `products/{productId}/{uuid}_{originalFileName}`
- **Brands**: `brands/{brandId}/{uuid}_{originalFileName}`
- **Banners**: `banners/{uuid}_{originalFileName}`

*Example*: `products/550e8400-e29b-41d4-a716-446655440000/a1b2c3d4_front_view.jpg`

## 3. Access Policies
- The `socduacl-public` bucket must have a public read policy assigned upon startup, allowing the frontend to load images directly via MinIO URL without presigned URLs.
- *Policy Example*:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": ["*"]},
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::socduacl-public/*"]
    }
  ]
}
```

## 4. Upload Workflow
1. The Admin client requests an upload from the Backend.
2. The Backend validates permissions and file type/size.
3. The Backend interacts with MinIO (via AWS S3 SDK or MinIO SDK) to upload the file.
4. The Backend stores the `minio_object_key` in the PostgreSQL database.
5. Alternatively, the Backend generates a **Presigned URL** for the Admin client to upload directly to MinIO to save backend bandwidth. For the MVP, backend proxying is acceptable for simplicity unless files are very large.

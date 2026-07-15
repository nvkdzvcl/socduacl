import { z } from "zod";

const isValidBaseUrl = (value: string) => {
  if (value.startsWith("/")) {
    return true;
  }

  try {
    new URL(value);
    return true;
  } catch {
    return false;
  }
};

const baseUrlSchema = z
  .string()
  .min(1)
  .refine(isValidBaseUrl, "Must be an absolute URL or root-relative path");

const publicEnvSchema = z.object({
  NEXT_PUBLIC_API_BASE_URL: baseUrlSchema.default(
    "http://localhost:8080/api/v1",
  ),
  NEXT_PUBLIC_MEDIA_BASE_URL: baseUrlSchema.default(
    "http://localhost:9000/socduacl-public",
  ),
});

const publicEnv = publicEnvSchema.parse({
  NEXT_PUBLIC_API_BASE_URL: process.env.NEXT_PUBLIC_API_BASE_URL,
  NEXT_PUBLIC_MEDIA_BASE_URL: process.env.NEXT_PUBLIC_MEDIA_BASE_URL,
});

const trimTrailingSlash = (value: string) =>
  value === "/" ? "" : value.replace(/\/+$/, "");

export const env = {
  apiBaseUrl: trimTrailingSlash(publicEnv.NEXT_PUBLIC_API_BASE_URL),
  mediaBaseUrl: trimTrailingSlash(publicEnv.NEXT_PUBLIC_MEDIA_BASE_URL),
} as const;

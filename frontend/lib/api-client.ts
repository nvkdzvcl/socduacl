import { env } from "@/lib/env";

export type HttpMethod = "GET" | "POST" | "PUT" | "PATCH" | "DELETE";

export interface ApiRequestOptions<TBody = unknown>
  extends Omit<RequestInit, "body" | "method"> {
  body?: TBody;
  method?: HttpMethod;
}

export class ApiError extends Error {
  constructor(
    public readonly status: number,
    public readonly payload: unknown,
    message: string,
  ) {
    super(message);
    this.name = "ApiError";
  }
}

const buildApiUrl = (path: string) => {
  const normalizedPath = path.startsWith("/") ? path : `/${path}`;
  return `${env.apiBaseUrl}${normalizedPath}`;
};

const parseResponseBody = async (response: Response): Promise<unknown> => {
  if (response.status === 204) {
    return null;
  }

  const contentType = response.headers.get("content-type") ?? "";

  if (contentType.includes("application/json")) {
    return response.json() as Promise<unknown>;
  }

  return response.text();
};

const getErrorMessage = (payload: unknown) => {
  if (payload && typeof payload === "object" && "message" in payload) {
    const message = (payload as { message?: unknown }).message;

    if (typeof message === "string" && message.length > 0) {
      return message;
    }
  }

  return "Request failed";
};

export const apiRequest = async <TResponse, TBody = unknown>(
  path: string,
  options: ApiRequestOptions<TBody> = {},
): Promise<TResponse> => {
  const { body, headers: requestHeaders, method, ...init } = options;
  const headers = new Headers(requestHeaders);

  headers.set("Accept", headers.get("Accept") ?? "application/json");

  if (body !== undefined && !headers.has("Content-Type")) {
    headers.set("Content-Type", "application/json");
  }

  const response = await fetch(buildApiUrl(path), {
    ...init,
    body: body === undefined ? undefined : JSON.stringify(body),
    headers,
    method: method ?? (body === undefined ? "GET" : "POST"),
  });

  const payload = await parseResponseBody(response);

  if (!response.ok) {
    throw new ApiError(response.status, payload, getErrorMessage(payload));
  }

  return payload as TResponse;
};

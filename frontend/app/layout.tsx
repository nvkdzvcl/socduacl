import type { Metadata } from "next";
import { Inter } from "next/font/google";
import { AppProviders } from "@/providers/AppProviders";
import "./globals.css";

const inter = Inter({
  display: "swap",
  subsets: ["latin", "latin-ext", "vietnamese"],
  variable: "--font-inter",
});

export const metadata: Metadata = {
  title: {
    default: "Socduacl Commerce",
    template: "%s | Socduacl Commerce",
  },
  description: "Vietnamese streetwear commerce foundation.",
  applicationName: "Socduacl Commerce",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html className={inter.variable} lang="vi">
      <body className="bg-ink font-sans text-neutral-50 antialiased">
        <AppProviders>{children}</AppProviders>
      </body>
    </html>
  );
}

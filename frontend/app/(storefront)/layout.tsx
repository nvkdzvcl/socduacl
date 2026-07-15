import { SiteShell } from "@/components/layout/SiteShell";
import type { ReactNode } from "react";

interface StorefrontLayoutProps {
  children: ReactNode;
}

export default function StorefrontLayout({ children }: StorefrontLayoutProps) {
  return <SiteShell>{children}</SiteShell>;
}

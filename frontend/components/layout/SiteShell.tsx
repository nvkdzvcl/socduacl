import type { ReactNode } from "react";
import { SiteHeader } from "@/components/layout/SiteHeader";

interface SiteShellProps {
  children: ReactNode;
}

export function SiteShell({ children }: SiteShellProps) {
  return (
    <div className="min-h-screen overflow-hidden">
      <SiteHeader />
      <main>{children}</main>
    </div>
  );
}

"use client";

import Link from "next/link";
import { useUiStore } from "@/stores/ui-store";

export function SiteHeader() {
  const isMobileNavOpen = useUiStore((state) => state.isMobileNavOpen);
  const closeMobileNav = useUiStore((state) => state.closeMobileNav);
  const toggleMobileNav = useUiStore((state) => state.toggleMobileNav);

  const firstLineClass = isMobileNavOpen
    ? "translate-y-[7px] rotate-45"
    : "";
  const secondLineClass = isMobileNavOpen ? "opacity-0" : "";
  const thirdLineClass = isMobileNavOpen
    ? "-translate-y-[7px] -rotate-45"
    : "";

  return (
    <header className="border-b border-neutral-800 bg-ink/95">
      <div className="mx-auto flex h-24 w-full max-w-7xl items-center justify-between px-5 sm:px-8 lg:px-10">
        <Link
          className="text-xl font-black uppercase text-neutral-50"
          href="/"
          onClick={closeMobileNav}
        >
          Socduacl
        </Link>

        <div className="hidden items-center gap-3 text-sm font-bold uppercase text-neutral-300 md:flex">
          <span className="border border-neutral-700 px-3 py-2 text-acid">
            Đồ mới vừa đáp
          </span>
          <span className="border border-neutral-700 px-3 py-2">
            Chất phố Việt
          </span>
        </div>

        <button
          aria-expanded={isMobileNavOpen}
          aria-label={isMobileNavOpen ? "Đóng menu" : "Mở menu"}
          className="grid h-11 w-11 place-items-center border border-neutral-700 bg-neutral-950 text-neutral-50 transition hover:border-acid focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-acid md:hidden"
          onClick={toggleMobileNav}
          type="button"
        >
          <span
            aria-hidden="true"
            className="flex h-4 w-5 flex-col justify-between"
          >
            <span
              className={`block h-0.5 w-full bg-current transition ${firstLineClass}`}
            />
            <span
              className={`block h-0.5 w-full bg-current transition ${secondLineClass}`}
            />
            <span
              className={`block h-0.5 w-full bg-current transition ${thirdLineClass}`}
            />
          </span>
        </button>
      </div>

      {isMobileNavOpen ? (
        <nav
          aria-label="Điều hướng di động"
          className="border-t border-neutral-800 bg-neutral-950 px-5 py-4 md:hidden"
        >
          <Link
            className="block border border-neutral-800 px-4 py-3 text-sm font-black uppercase text-neutral-100"
            href="/"
            onClick={closeMobileNav}
          >
            Trang chủ
          </Link>
        </nav>
      ) : null}
    </header>
  );
}

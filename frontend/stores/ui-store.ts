"use client";

import { create } from "zustand";

interface UiState {
  closeMobileNav: () => void;
  isMobileNavOpen: boolean;
  openMobileNav: () => void;
  toggleMobileNav: () => void;
}

export const useUiStore = create<UiState>((set) => ({
  closeMobileNav: () => set({ isMobileNavOpen: false }),
  isMobileNavOpen: false,
  openMobileNav: () => set({ isMobileNavOpen: true }),
  toggleMobileNav: () =>
    set((state) => ({ isMobileNavOpen: !state.isMobileNavOpen })),
}));

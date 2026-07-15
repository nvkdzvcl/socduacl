const foundationItems = [
  "App Router",
  "Tailwind CSS",
  "TanStack Query",
  "Zustand UI state",
  "Form + Zod base",
];

export default function HomePage() {
  return (
    <section className="mx-auto flex min-h-[calc(100vh-96px)] w-full max-w-7xl flex-col justify-center px-5 py-12 sm:px-8 lg:px-10">
      <div className="grid gap-10 lg:grid-cols-[minmax(0,1.1fr)_minmax(320px,0.9fr)] lg:items-end">
        <div className="space-y-8">
          <p className="inline-flex border border-acid bg-acid px-3 py-1 text-xs font-black uppercase text-ink">
            Socduacl Commerce
          </p>

          <div className="space-y-5">
            <h1 className="max-w-4xl text-5xl font-black uppercase leading-none text-neutral-50 sm:text-6xl lg:text-8xl">
              Đồ mới vừa đáp.
            </h1>
            <p className="max-w-2xl text-lg font-semibold leading-8 text-neutral-200 sm:text-xl">
              Mặc chất, khỏi cần nói nhiều. Nền frontend đã sẵn sàng cho các
              bước storefront tiếp theo.
            </p>
          </div>
        </div>

        <div className="border border-neutral-700 bg-surface/90 p-5 [box-shadow:8px_8px_0_#b9ff2f] sm:p-6">
          <p className="text-sm font-black uppercase text-acid">Bản nền</p>
          <p className="mt-4 text-3xl font-black uppercase leading-tight text-neutral-50">
            Sẵn sàng lên fit.
          </p>
          <div className="mt-6 flex flex-wrap gap-2">
            {foundationItems.map((item) => (
              <span
                className="border border-neutral-700 bg-neutral-950 px-3 py-2 text-xs font-bold uppercase text-neutral-200"
                key={item}
              >
                {item}
              </span>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

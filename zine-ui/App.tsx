// App.tsx — Root for DIY Grow Shelf Zine Maker

import React from "react";
import PdfUploadSlot from "./components/PdfUploadSlot";
import Instructions from "./components/Instructions";

export default function App() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-green-100 to-green-200 flex flex-col items-center justify-center py-10">
      <h1 className="text-3xl font-bold text-green-900 mb-6">
        DIY Grow Shelf — Zine Maker
      </h1>
      <p className="text-gray-700 mb-8 max-w-xl text-center">
        Generate a printable, foldable zine from your{" "}
        <code>grow_shelf_zine.pdf</code> or upload your own pages below.
      </p>
      <PdfUploadSlot />
      <Instructions />
      <footer className="mt-10 text-xs text-gray-500">
        Made with pdf-lib & Vite • Modular Commons Project
      </footer>
    </div>
  );
}

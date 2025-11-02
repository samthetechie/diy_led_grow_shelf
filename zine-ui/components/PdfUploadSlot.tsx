// PdfUploadSlot.tsx — Handles file upload and auto-load fallback

import React, { useState, useEffect } from "react";
import { mergeZinePages, autoZine } from "../services/zineService";

export default function PdfUploadSlot() {
  const [pdfFiles, setPdfFiles] = useState<File[]>([]);
  const [downloadUrl, setDownloadUrl] = useState<string | null>(null);
  const [autoLoaded, setAutoLoaded] = useState(false);

  useEffect(() => {
    // Try to auto-load local zine if available
    (async () => {
      const blob = await autoZine();
      if (blob) {
        const url = URL.createObjectURL(blob);
        setDownloadUrl(url);
        setAutoLoaded(true);
      }
    })();
  }, []);

  async function handleUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const files = Array.from(e.target.files || []);
    setPdfFiles(files);
    const blob = await mergeZinePages(files);
    const url = URL.createObjectURL(blob);
    setDownloadUrl(url);
  }

  return (
    <div className="bg-white shadow p-4 rounded-lg w-full max-w-xl mx-auto text-center">
      {autoLoaded ? (
        <>
          <h2 className="text-lg font-bold text-green-700 mb-2">
            Auto-loaded local grow_shelf_zine.pdf
          </h2>
          <a
            href={downloadUrl || "#"}
            download="grow_shelf_zine_printable.pdf"
            className="inline-block mt-4 bg-green-700 text-white px-4 py-2 rounded"
          >
            Download Printable Zine
          </a>
        </>
      ) : (
        <>
          <label className="block text-gray-700 font-semibold mb-2">
            Upload up to 8 PDF pages
          </label>
          <input
            type="file"
            accept="application/pdf"
            multiple
            onChange={handleUpload}
            className="block mx-auto border border-gray-400 p-2 rounded"
          />
          {downloadUrl && (
            <a
              href={downloadUrl}
              download="zine-printable.pdf"
              className="inline-block mt-4 bg-green-700 text-white px-4 py-2 rounded"
            >
              Download Printable Zine
            </a>
          )}
        </>
      )}
    </div>
  );
}

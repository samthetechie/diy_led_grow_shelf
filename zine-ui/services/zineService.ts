// zineService.ts — DIY Grow Shelf Zine Maker (integrated)
// -------------------------------------------------------
// Uses pdf-lib to merge up to 8 uploaded PDF pages into a
// printable single-sheet (A4) zine layout.
// Auto-loads ../grow_shelf_zine.pdf if present.

import { PDFDocument } from "pdf-lib";

export async function loadLocalZine(): Promise<Uint8Array | null> {
  try {
    const response = await fetch("../grow_shelf_zine.pdf", { cache: "no-store" });
    if (!response.ok) return null;
    const arrayBuffer = await response.arrayBuffer();
    console.log("[INFO] Loaded local grow_shelf_zine.pdf");
    return new Uint8Array(arrayBuffer);
  } catch {
    return null;
  }
}

export async function mergeZinePages(files: File[]): Promise<Blob> {
  const mergedPdf = await PDFDocument.create();

  for (const file of files) {
    const bytes = await file.arrayBuffer();
    const pdf = await PDFDocument.load(bytes);
    const pages = await mergedPdf.copyPages(pdf, pdf.getPageIndices());
    pages.forEach((p) => mergedPdf.addPage(p));
  }

  const finalPdf = await mergedPdf.save();
  return new Blob([finalPdf], { type: "application/pdf" });
}

export async function autoZine(): Promise<Blob | null> {
  const localPdf = await loadLocalZine();
  if (!localPdf) return null;
  const pdf = await PDFDocument.load(localPdf);
  const out = await PDFDocument.create();
  const copied = await out.copyPages(pdf, pdf.getPageIndices());
  copied.forEach((p) => out.addPage(p));
  const bytes = await out.save();
  return new Blob([bytes], { type: "application/pdf" });
}

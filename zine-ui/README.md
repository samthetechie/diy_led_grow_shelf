## 🧩 `zine-ui/README.md`

````markdown
# DIY Grow Shelf — Zine Maker (Web UI)

A browser-based companion to the shell script build system.  
Automatically loads and arranges `../grow_shelf_zine.pdf` for folding and printing.

## Quickstart

```bash
cd zine-ui
npm install
npm run dev
````

Then open [http://localhost:5173](http://localhost:5173) and:

* If `../grow_shelf_zine.pdf` exists, it auto-loads.
* Otherwise, upload your own 1–8 PDFs.
* Download your printable zine.

## Integration

1. Run `./make_grow_shelf_zine.sh` to generate the zine.
2. Open this app for print layout and folding instructions.
3. Print → Fold → Share your project booklet!

```

## 🧩 Integration Summary

**Backend (CLI)** → Generates `grow_shelf_zine.pdf`  
**Frontend (React)** → Auto-imports + arranges printable zine  

Result: a fully automated **end-to-end open hardware publication toolchain** — build in Bash, render in browser.
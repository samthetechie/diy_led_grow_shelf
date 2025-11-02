#!/usr/bin/env bash
# ==============================================================
# make_grow_shelf_zine.sh
# --------------------------------------------------------------
# Generates a printable zine (PDF) of the "Window-Sill LED Grow Shelf"
# and rendered OpenSCAD images of the model.
# Works on Debian/Ubuntu systems. No Wiki duplication.
# ==============================================================

set -e

# ----- 1. Check for root or sudo -----
if [ "$EUID" -ne 0 ]; then
    echo "[INFO] Using sudo for package installation..."
    SUDO="sudo"
else
    SUDO=""
fi

# ----- 2. Update package lists -----
echo "[INFO] Updating apt package index..."
$SUDO apt-get update -y

# ----- 3. Install dependencies -----
echo "[INFO] Installing required packages..."
$SUDO apt-get install -y \
    pandoc \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-latex-recommended \
    texlive-latex-extra \
    openscad \
    imagemagick \
    nodejs \
    npm \
    qrencode

# ----- 4. Define filenames -----
SCAD_FILE="grow_shelf_model.scad"
RENDER_PNG="grow_shelf_render.png"
TEXTURE_PNG="grow_shelf_texture.png"
TRANSPARENT_PNG="grow_shelf_transparent.png"
ZINE_MD="grow_shelf_zine.md"
ZINE_PDF="grow_shelf_zine.pdf"
SCAD_HASH_FILE=".scad_hash"

# ----- 5. Create placeholder OpenSCAD model if missing -----
if [ ! -f "$SCAD_FILE" ]; then
    echo "[INFO] Writing placeholder OpenSCAD model to $SCAD_FILE ..."
    cat > "$SCAD_FILE" <<'EOF'
// Simple placeholder model (GridBeam frame + two trays)
beam = 18;
tray_L = 390;
tray_W = 230;
tray_H = 70;
z_gap = 310;
$fn = 64;

module beam(x,y,z){ cube([x,y,z], center=true); }

translate([0,0,0])      color("burlywood") beam(420,18,18);
translate([0,0,450])    color("burlywood") beam(420,18,18);
translate([0,0,225])    color("peru") cube([tray_L,tray_W,10], center=true);
translate([0,0,225+z_gap]) color("peru") cube([tray_L,tray_W,10], center=true);
EOF
else
    echo "[INFO] Using existing OpenSCAD model: $SCAD_FILE"
fi

# ----- 6. Render OpenSCAD models (with change detection) -----
echo "[INFO] Checking for SCAD model changes..."
NEW_HASH=$(md5sum "$SCAD_FILE" | awk '{print $1}')
OLD_HASH=$(cat "$SCAD_HASH_FILE" 2>/dev/null || echo "")

if [ "$NEW_HASH" != "$OLD_HASH" ]; then
    echo "[INFO] Model changed. Rendering OpenSCAD outputs..."
    openscad "$SCAD_FILE" -o "$RENDER_PNG" \
      --imgsize=1600,1200 --render=1 --viewall --autocenter \
      --projection=p --colorscheme="Solarized"

    openscad "$SCAD_FILE" -o "$TEXTURE_PNG" \
      --imgsize=1600,1200 --render=1 --viewall --autocenter \
      --projection=p --colorscheme="Nature"

    openscad "$SCAD_FILE" -o "$TRANSPARENT_PNG" \
      --imgsize=1600,1200 --render=1 --viewall --autocenter \
      --projection=p --colorscheme="Tomorrow Night"

    echo "$NEW_HASH" > "$SCAD_HASH_FILE"
    echo "[INFO] Renderings complete: $RENDER_PNG (Solarized) and $TEXTURE_PNG (Nature)"
else
    echo "[INFO] No model changes detected — skipping rendering."
fi

# ----- 7. Create Markdown zine -----
echo "[INFO] Writing Markdown zine file $ZINE_MD ..."
cat > "$ZINE_MD" <<EOF
# Window-Sill LED Grow Shelf
### GridBeam Edition (v4.1)
![Rendered model]($TRANSPARENT_PNG)
_Modular indoor garden built from wood, light, and logic._

## 1 — What This Is
![Rendered model]($RENDER_PNG)

A **two-level herb garden** for any windowsill.  
Built using the **GridBeam tri-joint system**.  
Each tray holds eight pots; the top tray lights the lower one with **5 V LEDs**.  
All parts are re-usable, screw-based, and repairable.

**Size:** 40×23×46 cm **Capacity:** 16 pots **Power:** 5 V DC  
**Skill:** Beginner / Maker

## 2 — Why GridBeam
Three beams meet at one node — X, Y, Z — forming a reusable tri-joint.  
GridBeam uses one beam profile, holes every 25 mm, and M5 bolts.  
It’s fast, strong, and circular-economy friendly.

## 3 — Bill of Materials
**Frame**
- 4 m of 18×18 mm pine/beech  
- 4 × 400 mm (X), 4 × 230 mm (Y), 4 × 450 mm (Z)  
- 24 × M5 bolts + nuts + washers  

**Trays & Pots**
- 2 × baking trays (39×23×7 cm)  
- 16 × pots Ø 70 mm × H 80 mm  
- Potting soil  

**Lighting**
- 1 m 5 V red/blue LED strip  
- 5 V 2 A adapter, 22 AWG wire  
- Heat-shrink, solder, digital timer, extension lead

## 4 — Tools
Saw / mitre box • Drill (5 mm) • Screwdriver or spanner  
Solder iron • Heat-gun • Multimeter • Square • Tape • IPA cleaner  

## 5 — Build the Frame
1. **Drill holes** every 25 mm on beam centerlines (Ø 5 mm).  
2. **Bolt base corners:** X + Y + Z beams form each tri-joint (3 bolts).  
3. **Add upper rails** ~ 310 mm above lower tray.  
4. **Seat trays** flat on beam tops (15 mm wall gap).  

## 6 — Add Pots & Soil
Each tray holds 8 pots (2×4) with ~ 35 mm gap from walls.  
Fill with soil and herbs (basil, mint, thyme).  
Cut drainage holes if using tetra packs.

## 7 — LED Wiring
1. **Cut strip** to fit tray underside (~ 35 cm runs).  
2. **Solder** red to +5 V, black to –; join segments with jumpers.  
3. **Insulate** with heat-shrink; test polarity.  
4. **Clean and stick** strip under upper tray; glue ends if needed.  
5. **Power** via adapter → timer → wall.  
Set timer: 12–14 h ON (winter) / 8–10 h ON (summer).  

## 8 — Safety & Use
Keep electrics dry; route cables down rear post.  
Tighten bolts monthly, trim plants weekly.  
Optional: foil reflector or PWM dimmer.  

## Back Page
![Textured render]($TEXTURE_PNG)
**LED Circuit Sketch**
\`\`\`
+5V Adapter → Timer → LED Strips  
Red → +5 V Black → GND
\`\`\`
**Quote**  
> “Make it modular, make it honest, make it easy to rebuild.”  
EOF

# ----- 8. Generate PDF using pandoc -----
echo "[INFO] Rendering final PDF..."
pandoc "$ZINE_MD" \
  --from markdown \
  --to pdf \
  --pdf-engine=xelatex \
  --metadata title="Window-Sill LED Grow Shelf – GridBeam Edition" \
  --variable papersize=A4 \
  --variable geometry:"margin=1.5cm" \
  --variable fontsize=11pt \
  --resource-path=. \
  -o "$ZINE_PDF"

# ----- 9. GitHub Push (SSH only, no Wiki) -----
if [ ! -f ".env" ]; then
    echo "[INFO] .env not found. Creating one interactively..."
    read -p "Enter your GitHub username: " gh_user
    echo "GITHUB_USERNAME=$gh_user" > .env
    echo "[INFO] .env created with GITHUB_USERNAME=$gh_user"
fi

# Source after creation
source .env
GITHUB_USER="$GITHUB_USERNAME"

if [ -z "$GITHUB_USER" ]; then
    echo "[ERROR] GITHUB_USERNAME not set. Please edit .env and add: GITHUB_USERNAME=<yourname>"
    exit 1
fi

REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo diy_led_grow_shelf)")
MAIN_REPO_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}.git"
git config --global url."git@github.com:".insteadOf "https://github.com/"

read -p "Do you want to push updates (model, zine, and renders) to GitHub? [y/N] " push_answer
if [[ "$push_answer" =~ ^[Yy]$ ]]; then
    echo "[INFO] Pushing updates to GitHub via SSH..."
    git add grow_shelf_model.scad grow_shelf_zine.md grow_shelf_zine.pdf *.png
    git commit -m "Auto-update zine, model, and renders" || true
    git push "$MAIN_REPO_URL" main && echo "[INFO] Repository updated successfully."
fi


# ==============================================================
# 10. Local Zine Preview via Python HTTP + QR Code (Auto Network Detection)
# ==============================================================

echo "[INFO] Setting up lightweight local zine preview server..."

# Ensure qrencode is installed
if ! command -v qrencode >/dev/null 2>&1; then
    echo "[INFO] Installing qrencode..."
    $SUDO apt-get install -y qrencode
fi

# Ensure Python3 is available
if ! command -v python3 >/dev/null 2>&1; then
    echo "[ERROR] Python3 not found. Please install it first."
    exit 1
fi

# Pick random port between 1024–65535
PORT=$((1024 + RANDOM % 64511))

# Detect primary network interface and IP address
PRIMARY_IF=$(ip route get 1.1.1.1 2>/dev/null | awk '/dev/ {print $5; exit}')
IP=$(ip -4 addr show "$PRIMARY_IF" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)

if [ -z "$IP" ]; then
    echo "[WARNING] Could not auto-detect IP. Falling back to hostname -I."
    IP=$(hostname -I | awk '{print $1}')
fi

if [ -z "$IP" ]; then
    echo "[ERROR] No valid IPv4 address found. Connect to a network and retry."
    exit 1
fi

# Start Python HTTP server in background
echo "[INFO] Serving current directory on interface: $PRIMARY_IF ($IP)"
python3 -m http.server "$PORT" &>/dev/null &
SERVER_PID=$!

# Wait briefly for server start
sleep 1

# Generate QR code pointing to local HTTP address
URL="http://$IP:$PORT"
echo
echo "[INFO] Scan this QR code to open on your phone or tablet:"
qrencode -m 2 -t utf8 <<< "$URL"
echo
echo "[INFO] Local preview available at: $URL"
echo "[INFO] Press Enter to stop the preview server..."
read -r

# Clean up background process
kill "$SERVER_PID" 2>/dev/null
echo "[INFO] Server stopped."

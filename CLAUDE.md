# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal clinical dashboard (PWA) tracking foot recovery (fascitis plantar + peroneu curt + Aquil·les). Written in Catalan. Pure vanilla HTML/CSS/JS — no build tools, no package manager, no framework. The entire application lives in a single `index.html` file (≈2,760 lines).

**Deployed:** GitHub Pages at `https://DavidParet.github.io/lesio-peu-dashboard/`

## Running Locally

No build step. Serve the root directory with any static server:

```bash
python3 -m http.server 8080
# or
npx serve .
```

Open `http://localhost:8080`. Opening `index.html` as `file://` will fail (CORS on CSV fetch).

## Deploying

Push to `main` branch — GitHub Pages rebuilds automatically in ~2 minutes:

```bash
git add .
git commit -m "Update: description"
git push
```

The `.bat` files (`push.bat`, `deploy-github.bat`, `update-github.bat`) are Windows helpers for the same operations.

## Architecture

### Single-file structure

`index.html` has three sections:
1. `<style>` — all CSS with design tokens in `:root` CSS variables
2. `<body>` — minimal shell: sticky header + `<div id="main">` (loading spinner, replaced on render)
3. `<script>` — all application logic, clearly sectioned with `/* ═══ SECTION ═══ */` comments

External dependency: **Chart.js v4.5.0** loaded from CDN with SRI hash (line 359).

### Data loading pipeline

`load()` tries four sources in order, stops at the first that returns valid rows:

1. `GOOGLE_SHEET_URL` — Google Sheets published as CSV (configured at top of `<script>`)
2. `./data/registre.csv` — local CSV file committed to the repo (79 days of sample data)
3. `localStorage` (key `peu_recovery_csv`) — previously saved CSV from a manual upload
4. Manual file picker fallback (`showManualCsvFallback()`)

`parseCSV()` auto-detects `;` vs `,` separator and handles quoted fields. `parseRows()` converts raw CSV objects into typed row objects stored in the global `ALL` array.

### Parsed row schema

```js
{
  iso,      // "YYYY-MM-DD" (dates assume year 2026)
  dia,      // recovery day number
  score,    // "Y numèrica" — composite pain 0–5 (lower = better)
  passos,   // steps
  son,      // sleep hours (decimal)
  qualitat, // sleep quality 0–100
  magneto,  // magnetotherapy hours
  fisio,    // boolean (starts with "S" = true)
  exercicis,// boolean
  dolorM,   // morning pain 0–5
  dolorV,   // evening pain 0–5
  coixesa,  // limping score 0–5
  inflam,   // inflammation score 0–5
  trigger,  // string label (e.g. "CÀRREGA", "DESCÀRREGA")
  obs       // free-text observations
}
```

### Render pipeline

`render(rows)` builds the full dashboard:

1. Computes derived values: 7d moving average, trend delta (avg7 vs avg14–7), risk badge, recovery score (0–100), monitoring state
2. Builds HTML string array `H[]` using `build*()` functions, concatenates and sets `document.getElementById('main').innerHTML`
3. Calls all chart draw functions after DOM insertion

**Section render order:**
Hero → Metrics grid → Clinical analysis (IA narrative) → Context card → Correlation chart → Step tolerance → Timeline charts → Weekly summary → Auto-insights → Recovery milestones → Medical history → Weekly table

### Key computations

- **`computeRecoveryScore()`** — composite 0–100: pain 50 pts + lameness 15 + inflammation 10 + steps 10 + sleep 5 + trend bonus (±10) − relapse penalty (3 pts per peak ≥3.5 in last 7 days)
- **`computeRisk()`** — outputs one of: `risk-estable`, `risk-vigilancia`, `risk-sobrecarrega`, `risk-regresio`
- **`computeFase()`** — classifies recovery phase: Aguda / Subaguda / Consolidació / Recuperació funcional / Manteniment
- **`computeInsights()`** — generates clinical bullet points from data patterns
- **`detectVisits()`** — scans `obs` + `trigger` fields with regex to find medical appointments

### Charts

All charts use Chart.js v4 stored in globals `CHART_OBJ`, `CHART1_OBJ`…`CHART6_OBJ`. The hero sparkline uses raw Canvas 2D (no Chart.js).

| Function | Chart var | Content |
|---|---|---|
| `drawChart()` | `CHART_OBJ` | Main timeline: comfort + pain lines + zone backgrounds + event markers |
| `drawDolorDiari()` | `CHART1_OBJ` | Daily morning/evening pain bars |
| `drawPassosDolor()` | `CHART2_OBJ` | Steps vs pain correlation |
| `drawSetmanal()` | `CHART3_OBJ` | Weekly average bar chart |
| `drawToleranceChart()` | `CHART4_OBJ` | Step tolerance zone analysis |
| `drawCarregaChart()` | `CHART5_OBJ` | Weekly load chart |
| `drawEficienciaChart()` | `CHART6_OBJ` | Load efficiency chart |

**Custom Chart.js plugins** (registered inline, not globally):
- `painZonesPlugin` / `comfortZonesPlugin` — colored background bands
- `baselineS4Plugin` — dashed reference line at score 2.38 (Dr. Ríos clinical baseline)
- `makeEventsPlugin()` — vertical dashed lines for medical visits
- `makeWorstPlugin()` — numbered red circles on worst-day data points
- `makeValueLabelsPlugin()` — value labels above bars

### AI integration

The `render()` function builds a Catalan clinical prompt but immediately throws `new Error('Mode autònom: fallbacks actius.')` — AI is intentionally disabled. All text (`aiMsg`, `aiCtx`, `aiPred`, `aiCentral`) falls back to computed values from `buildClinicTag()` and `centralFallback`. The dead AI code is preserved for future re-enablement.

### PWA / Service Worker

`service-worker.js` cache name is `peu-recovery-v4`. Strategy: CSV and spreadsheet URLs always bypass cache (`no-store`); all other assets use network-first with offline fallback. When bumping the cache version, update the string in `service-worker.js`.

## CSS Design System

All colors and spacing use CSS custom properties defined in `:root`. Color semantics:
- `--amber` / `--amber-bg` — primary brand, score accent
- `--green` / `--green-bg` — good state, improvement
- `--orange` / `--orange-bg` — alert, moderate overload
- `--red` / `--red-bg` — critical, regression
- `--blue` / `--blue-bg` — informational, step-tolerance section

Metric card coloring uses `mc-good` / `mc-ok` / `mc-warn` / `mc-alert` / `mc-crit` / `mc-info` border-left classes. Corresponding text colors are `c-good` / `c-ok` / `c-warn` / `c-bad` / `c-crit` / `c-neut` / `c-blue`.

## Data File

`data/registre.csv` contains 79 days of records (March–June 2026). When adding new rows:
- Date format: `DD-mes` where month is Catalan abbreviation (e.g. `20-juny`)
- `Fisio` / `Exercicis` columns: `Sí` or `No`
- `Magneto` column: hours as `2h`, `1h30`, or decimal
- `Son` column: `7h30` or `6h45` format
- Empty cells are valid — `pNum()`, `pSteps()`, `pHours()` all handle missing values gracefully

## Updating the Google Sheet URL

In `index.html`, find `const GOOGLE_SHEET_URL = '...'` near line 403. Replace with the published CSV URL from Google Sheets (Fitxer → Compartir → Publica al web → Full 1 → CSV format).

# Seguiment Clínic Peu — Dashboard Web

Dashboard clínic de seguiment de recuperació del peu (fascitis plantar + peroneu curt + Aquil·les).
Funciona des de qualsevol navegador. Instal·lable com app al mòbil (PWA).

---

## 🚀 Publicar a GitHub Pages — 5 passos

### Pas 1 — Crear repositori a GitHub
1. Ves a [github.com/new](https://github.com/new)
2. Nom del repositori: `lesio-peu-dashboard`
3. Visibilitat: **Public** (necessari per GitHub Pages gratuït)
4. **No** inicialitzis amb README (ja en tenim un)
5. Clica "Create repository"

### Pas 2 — Obrir terminal a la carpeta DASHBOARD_WEB
```
cd "Z:\My Folders\04_CLAUDE_COWORK\01_PROJECTS\Lesio_peu\DASHBOARD_WEB"
```

### Pas 3 — Inicialitzar i pujar (substitueix TU_USUARI)
```bash
git init
git add .
git commit -m "Initial version: dashboard clínic peu"
git branch -M main
git remote add origin https://github.com/TU_USUARI/lesio-peu-dashboard.git
git push -u origin main
```

### Pas 4 — Activar GitHub Pages
1. Ves al repositori → **Settings** → **Pages**
2. Source: **Deploy from a branch**
3. Branch: **main** → **/ (root)**
4. Clica **Save**

### Pas 5 — La URL pública estarà disponible en ~2 minuts
```
https://TU_USUARI.github.io/lesio-peu-dashboard/
```

---

## 🔄 Actualitzar el dashboard en el futur

Quan facis canvis al `index.html` o qualsevol fitxer:
```bash
git add .
git commit -m "Update: descripció del canvi"
git push
```
GitHub Pages s'actualitza automàticament en 1–2 minuts.

---

## 📊 Configurar les dades

### Opció A — Google Sheets (recomanat)
1. Obre el teu Google Sheet
2. **Fitxer → Compartir → Publica al web → Full 1 → CSV**
3. Copia la URL generada
4. A `index.html`, busca `const GOOGLE_SHEET_URL = ''` i enganxa la URL entre les cometes

### Opció B — CSV local
1. Exporta el Google Sheet com CSV
2. Desa'l com `data/registre.csv`
3. Fes `git add . && git commit -m "Update data" && git push`

### Opció C — Càrrega manual
Obre el dashboard i usa el botó "Seleccionar registre CSV".

---

## 📱 Instal·lar com app al mòbil (PWA)

- **Android (Chrome)**: Menú ⋮ → "Afegir a la pantalla d'inici"
- **iPhone (Safari)**: Compartir ↑ → "Afegir a la pantalla d'inici"
- **Escriptori (Chrome)**: Icona d'instal·lació a la barra d'adreces

---

## 🗂 Estructura del projecte

```
DASHBOARD_WEB/
├── index.html          ← Dashboard principal (punt d'entrada)
├── manifest.json       ← Configuració PWA
├── service-worker.js   ← Cache offline
├── .gitignore          ← Fitxers ignorats per Git
├── README.md           ← Aquesta guia
├── data/
│   └── registre.csv    ← Dades d'exemple
├── icons/
│   ├── icon-192.png
│   ├── icon-512.png
│   └── icon.svg
├── css/                ← Per a futures separacions de CSS
├── js/                 ← Per a futures separacions de JS
└── assets/             ← Per a imatges i recursos
```

---

## 🔒 Privacitat

- El dashboard **no envia cap dada** a cap servidor extern.
- Si uses Google Sheets publicat, les dades seran accessibles a qualsevol persona amb la URL.
- Per fer-ho privat: considera un hosting amb autenticació o no publicar el Google Sheet.

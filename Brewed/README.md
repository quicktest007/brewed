# Brewed

A social app for coffee lovers — taste, rate, and discover.

- **iOS app** — SwiftUI app (open in Xcode)
- **Web** — Static site at [https://quicktest007.github.io/brewed/](https://quicktest007.github.io/brewed/)

---

## Web (React + Vite + TypeScript)

### Run locally

```bash
cd web
npm install
npm run dev
```

Open [http://localhost:5173](http://localhost:5173).

### Build for production

```bash
cd web
npm run build
```

Output goes to `web/dist/`.

### Deploy to GitHub Pages

Pushing to `main` triggers the GitHub Actions workflow, which builds the web app and deploys to GitHub Pages.

**One-time setup:** In your repo **Settings → Pages**, set **Source** to **GitHub Actions**.

---

## Web structure

- **Landing** — Hero, tagline, links to Feed / Map / Add Brew
- **Feed** — Mock brew cards (rating beans, coffee type, place, tasting notes)
- **Map** — Placeholder + list of nearby places (full map in iOS app)
- **Add Brew** — Form: rating, at home/shop, coffee type, tasting notes, comments

---

## iOS app

Open `Brewed.xcodeproj` in Xcode and run on simulator or device.

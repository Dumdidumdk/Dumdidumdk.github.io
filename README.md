# Dumdidumdk.github.io

Hjemmesiden er flyttet til **https://brixel.dk**.

Dette repo sender de gamle adresser videre: `dumdidumdk.github.io/apps/<sti>` → `https://brixel.dk/<sti>` (samme sti, `?query` og `#hash`). Alle andre stier, fx `/fugleklatten/`, går til samme sti på brixel.dk.

- `404.html` fanger alle stier (JavaScript-viderestilling).
- `apps/<app>/index.html` findes for hver app, så også browsere uden JavaScript og søgemaskiner (meta refresh + canonical) lander det rigtige sted.
- `apps/servermester/version.json` og `ServerMester-1.5.0.exe` ligger her som rigtige filer, fordi ServerMester-programmer, der allerede er installeret, tjekker for opdateringer på `https://dumdidumdk.github.io/apps/servermester/version.json` (et program følger ikke en JavaScript-viderestilling). Adressen i `version.json` er underskrevet, så den må ikke rettes i hånden. Ved en ny ServerMester-udgivelse skal den nye `version.json` (og exe-filen, hvis adressen peger herhen) også lægges her.

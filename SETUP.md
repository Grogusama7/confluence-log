# Confluence Log — mise en ligne (GitHub Pages + synchro Supabase)

Objectif : ton **journal de trading** accessible **depuis n'importe quel appareil**, en privé
(connexion e-mail + mot de passe), avec les données **synchronisées dans le cloud** — exactement
comme ton app PMO « Suivi de projets ».

- `index.html` → l'app cloud (login + synchro Supabase + cache local hors-ligne). C'est le fichier servi par GitHub Pages.
- `supabase/schema.sql` → la table à créer dans Supabase (une seule fois).

> **Bonne nouvelle :** ce projet **réutilise ton projet Supabase existant** (celui de « Suivi de projets »,
> `vslghmluhzjzsczbrryd.supabase.co`). L'URL et la clé publique sont **déjà câblées** dans `index.html`,
> et tu te connecteras avec **le même e-mail + mot de passe** que pour le PMO. Tu n'as donc qu'**une seule**
> chose à faire côté Supabase : créer la table ci-dessous.

---

## Étape 1 — Créer la table dans Supabase (2 min)

1. Va sur https://supabase.com → ouvre ton projet **suivi-projets**.
2. Menu de gauche → **SQL Editor** → **New query**.
3. Ouvre `supabase/schema.sql`, copie tout, colle, clique **Run**.
4. Tu dois voir *Success. No rows returned.* → la table `trading_journal_state` + sa sécurité RLS sont créées.

C'est tout pour Supabase. (La table cohabite avec `pmo_state`, aucun conflit.)

> Si un jour tu veux un **projet Supabase séparé** pour le trading : crée un nouveau projet, exécute
> `schema.sql` dedans, puis remplace `SUPA_URL` et `SUPA_ANON` en haut du `<script>` de `index.html`.

---

## Étape 2 — Mettre le site en ligne sur GitHub Pages

### Option A — via la ligne de commande (`gh`)

> `gh` n'est pas encore connecté sur cette machine. Une seule fois :

```bash
gh auth login          # choisis : GitHub.com → HTTPS → Login with a web browser
```

Puis, depuis le dossier `confluence-log/` (le repo git est déjà initialisé et commité) :

```bash
gh repo create confluence-log --public --source=. --remote=origin --push
```

Active ensuite Pages :

```bash
gh api -X POST repos/{owner}/confluence-log/pages -f "source[branch]=main" -f "source[path]=/"
```

*(ou via l'interface, voir Option B étape 3.)*

### Option B — via le site GitHub (sans CLI)

1. https://github.com/new → **Repository name** : `confluence-log` → **Public** → **Create repository**.
2. Suis la section « …or push an existing repository » affichée par GitHub :
   ```bash
   git remote add origin https://github.com/<ton-user>/confluence-log.git
   git branch -M main
   git push -u origin main
   ```
3. Dans le repo → **Settings** → **Pages** → **Source : Deploy from a branch** → branche **main**, dossier **/(root)** → **Save**.

### Résultat

Au bout d'une minute, ton site est en ligne à :

```
https://<ton-user>.github.io/confluence-log/
```

Ouvre-le → écran de connexion → tes identifiants (les mêmes que le PMO) → ton journal est là, synchronisé.

---

## Comment ça marche / bon à savoir

- **Synchro** : chaque modif est écrite en cache local (`localStorage`) **et** poussée dans Supabase (différé ~1 s).
  Le badge en haut à droite indique l'état : `✓ Synchronisé`, `⟳ Synchro…`, `⚠ Hors-ligne`.
- **Multi-appareils** : connecte-toi avec le même compte sur ton téléphone/laptop → mêmes données.
  (Modèle simple « dernière écriture gagne » ; évite d'éditer en parallèle sur 2 appareils en même temps.)
- **Sauvegarde** : le bouton **⤓ Export** télécharge un JSON complet ; **⤒ Import** le restaure. À faire de temps en temps par sécurité.
- **Confidentialité** : le repo public ne contient **que le code de l'app** — aucune donnée. Tes notes/trades vivent dans
  Supabase, derrière ta connexion (Row Level Security : tu ne vois que ta propre ligne). La clé `anon`/`publishable`
  dans `index.html` est **faite pour être publique**, elle ne donne accès à rien sans login.

## Mettre à jour le site plus tard

Après une modif de `index.html` :

```bash
git add -A && git commit -m "maj" && git push
```

GitHub Pages se redéploie tout seul en ~1 min.

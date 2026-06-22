# Confluence Log — journal de trading

Application web mono-fichier (un seul `index.html`, sans build) pour tenir un **journal de trading**
structuré autour d'un framework de confluence vol/options.

> **Mise en ligne :** voir [`SETUP.md`](SETUP.md) (GitHub Pages + synchro Supabase, ~5 min).

## Ce que fait l'app

- **Aujourd'hui** — cockpit du jour : régime de marché, garde-fous (droit de trader), risk dashboard
  (circuit breakers), heures dangereuses, rythme **GMT** du desk, note de séance à froid.
- **Timeline** — fil chronologique unique : notes, trades, confluences, entrées de journal.
- **Journal / Trades / Confluences** — saisie riche (texte, images, docs), tags, lentilles.
- **Stats** — graphiques configurables (P&L, discipline, répartition par tag/lentille…).
- **Tags** — catégories personnalisables (régime, lentille dominante, setup, psychologie, qualité, classe d'actif).

Les **lentilles** du framework : `GEX` (Gamma Exposure), `Vega` (VIX/VVIX), `RR` (Risk Reversal 25Δ),
`Term` (term structure VX1–VX3), `Phys` (signaux physiques).

## Données & synchro

- Connexion e-mail + mot de passe (**Supabase Auth**).
- Synchro cloud automatique (table `trading_journal_state`, JSONB, **RLS** par utilisateur) + cache local hors-ligne.
- Export / Import JSON intégrés pour les sauvegardes.

## Pile technique

HTML/CSS/JS vanille + [`@supabase/supabase-js`](https://github.com/supabase/supabase-js) via CDN.
Aucune dépendance à installer, aucun backend à héberger : GitHub Pages sert le fichier statique,
Supabase gère l'auth et la persistance.

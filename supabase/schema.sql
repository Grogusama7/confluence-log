-- ============================================================
--  Confluence Log — schéma Supabase (synchro cloud + auth)
--  À exécuter UNE FOIS dans Supabase  ▸  SQL Editor  ▸  Run.
--  Modèle : 1 ligne par utilisateur ; tout l'état de l'app
--  (DB du journal) est stocké en JSONB — même structure que
--  l'export JSON local (bouton ⤓ Export).
--
--  NB : ce projet réutilise ton projet Supabase existant
--  (celui de "Suivi de projets"). Cette table cohabite avec
--  pmo_state sans aucun conflit — c'est juste une table de plus.
-- ============================================================

-- 1) Table d'état applicatif -------------------------------------------------
create table if not exists public.trading_journal_state (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- 2) Row Level Security : chacun ne lit/écrit QUE sa propre ligne ------------
alter table public.trading_journal_state enable row level security;

drop policy if exists "tjs_select_own" on public.trading_journal_state;
create policy "tjs_select_own" on public.trading_journal_state
  for select using (auth.uid() = user_id);

drop policy if exists "tjs_insert_own" on public.trading_journal_state;
create policy "tjs_insert_own" on public.trading_journal_state
  for insert with check (auth.uid() = user_id);

drop policy if exists "tjs_update_own" on public.trading_journal_state;
create policy "tjs_update_own" on public.trading_journal_state
  for update using (auth.uid() = user_id)
            with check (auth.uid() = user_id);

-- ============================================================
-- Wordstack — Supabase one-time setup
-- Paste this whole file into: Supabase Dashboard → SQL Editor → Run
-- ============================================================

-- ---------- word sets ----------
create table if not exists public.word_sets (
  id          uuid primary key,
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  word        text not null,
  native_lang text,
  target_lang text,
  voice       text,
  data        jsonb,                       -- definition, translation, 6 sentences (no audio)
  deleted     boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists word_sets_user_updated on public.word_sets (user_id, updated_at);

alter table public.word_sets enable row level security;
drop policy if exists "own word_sets" on public.word_sets;
create policy "own word_sets" on public.word_sets
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ---------- SRS review state (one row per card) ----------
create table if not exists public.reviews (
  card_id    text primary key,             -- "<set uuid>|<deck>|<idx>"
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  set_id     uuid not null,
  deck       text not null,                -- reading | listening | speaking
  idx        int  not null,
  state      text not null,                -- new | learning | relearning | review
  step       int  not null default 0,
  ivl        int  not null default 0,      -- interval in days
  ef         float8 not null default 2.5,  -- ease factor
  reps       int  not null default 0,
  lapses     int  not null default 0,
  due_at     timestamptz not null,
  updated_at timestamptz not null default now()
);
create index if not exists reviews_user_updated on public.reviews (user_id, updated_at);

alter table public.reviews enable row level security;
drop policy if exists "own reviews" on public.reviews;
create policy "own reviews" on public.reviews
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ---------- review log (append-only; powers the statistics dashboard) ----------
create table if not exists public.revlog (
  id         uuid primary key,
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  card_id    text not null,
  set_id     uuid not null,
  lang       text,                         -- target language, so stats can be per-language
  deck       text,                         -- reading | listening | speaking
  rating     text not null,                -- again | hard | good | easy
  state      text,                         -- resulting state after the answer
  ivl        int,                          -- resulting interval in days
  at         timestamptz not null,         -- when the card was answered
  updated_at timestamptz not null default now()
);
create index if not exists revlog_user_updated on public.revlog (user_id, updated_at);
create index if not exists revlog_user_at      on public.revlog (user_id, at);

alter table public.revlog enable row level security;
drop policy if exists "own revlog" on public.revlog;
create policy "own revlog" on public.revlog
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ---------- private audio bucket (mp3 per sentence) ----------
insert into storage.buckets (id, name, public)
values ('audio', 'audio', false)
on conflict (id) do nothing;

-- Files live at <user_id>/<set_id>/<idx>.mp3 — each user can touch only their own folder.
drop policy if exists "own audio read"   on storage.objects;
drop policy if exists "own audio write"  on storage.objects;
drop policy if exists "own audio update" on storage.objects;
drop policy if exists "own audio delete" on storage.objects;

create policy "own audio read" on storage.objects for select
  using (bucket_id = 'audio' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own audio write" on storage.objects for insert
  with check (bucket_id = 'audio' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own audio update" on storage.objects for update
  using (bucket_id = 'audio' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own audio delete" on storage.objects for delete
  using (bucket_id = 'audio' and (storage.foldername(name))[1] = auth.uid()::text);

-- Spaced repetition over the vocabulary Fluent Loop already saves.
-- Ported from Wordstack: one card set per phrase (6 generated sentences),
-- 13 cards per set (1 reading + 6 listening + 6 speaking), SM-2 scheduling.
--
-- Everything is scoped the way the rest of this app is scoped:
-- (user_id = learner profile, target_language). No auth, anon key only.

-- ---------- generated card sets ----------
create table if not exists public.vocab_sets (
  id              uuid primary key default gen_random_uuid(),
  user_id         text not null default 'default_user',
  target_language text not null default 'German',
  vocab_id        uuid references public.target_vocabulary(id) on delete cascade,
  phrase          text not null,
  voice           text,
  data            jsonb not null,   -- definition, word_translation, sentences[{target,native,word_form}]
  audio           jsonb,            -- array of base64 mp3, index-aligned with sentences
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index if not exists vocab_sets_scope
  on public.vocab_sets (user_id, target_language, created_at);
create unique index if not exists vocab_sets_one_per_phrase
  on public.vocab_sets (user_id, target_language, vocab_id);

-- ---------- SRS state: one row per card ----------
create table if not exists public.srs_reviews (
  card_id         text primary key,          -- "<set uuid>|<deck>|<idx>"
  user_id         text not null default 'default_user',
  target_language text not null default 'German',
  set_id          uuid not null references public.vocab_sets(id) on delete cascade,
  deck            text not null,             -- reading | listening | speaking
  idx             int  not null,
  state           text not null default 'new',   -- new | learning | relearning | review
  step            int  not null default 0,
  ivl             int  not null default 0,       -- interval in days
  ef              float8 not null default 2.5,   -- ease factor
  reps            int  not null default 0,
  lapses          int  not null default 0,
  due_at          timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index if not exists srs_reviews_scope
  on public.srs_reviews (user_id, target_language, due_at);
create index if not exists srs_reviews_set
  on public.srs_reviews (set_id);

-- ---------- append-only review log (drives the statistics) ----------
create table if not exists public.srs_revlog (
  id              uuid primary key default gen_random_uuid(),
  user_id         text not null default 'default_user',
  target_language text,
  card_id         text not null,
  set_id          uuid,
  deck            text,
  rating          text not null,             -- again | hard | good | easy
  state           text,                      -- resulting state
  ivl             int,                       -- resulting interval in days
  was_new         boolean not null default false,  -- powers the daily new-card cap
  at              timestamptz not null default now()
);

create index if not exists srs_revlog_scope
  on public.srs_revlog (user_id, target_language, at);

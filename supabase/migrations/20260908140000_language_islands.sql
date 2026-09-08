-- Language islands: a themed domain the learner wants to own, plus an
-- AI-designed roadmap of stages that builds it one session at a time.
--
-- Scoped like everything else: (user_id = learner profile, target_language).

create table if not exists public.islands (
  id              uuid primary key default gen_random_uuid(),
  user_id         text not null default 'default_user',
  target_language text not null default 'German',
  name            text not null,          -- "My work as a backend developer"
  goal            text,                   -- why this island is worth owning
  about_you       text,                   -- the learner's own words, used for planning
  status          text not null default 'active',  -- active | archived | done
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- One island in play per learner per language; archived ones are unlimited.
create unique index if not exists islands_one_active
  on public.islands (user_id, target_language)
  where status = 'active';

create index if not exists islands_scope
  on public.islands (user_id, target_language, status);

create table if not exists public.island_stages (
  id              uuid primary key default gen_random_uuid(),
  island_id       uuid not null references public.islands(id) on delete cascade,
  user_id         text not null default 'default_user',
  target_language text not null default 'German',
  position        int  not null,
  title           text not null,
  objective       text,                   -- what you must be able to do
  scenario        text,                   -- the situation to practise it in
  structures      jsonb,                  -- grammar to lean on, array of strings
  phrases         jsonb,                  -- [{phrase, translation, note}]
  done_when       text,                   -- the human-readable completion test
  recycles_from   jsonb,                  -- earlier positions this stage reuses
  status          text not null default 'locked',   -- locked | current | done
  ai_verdict      boolean not null default false,   -- analysis says the objective was met
  seeded          boolean not null default false,   -- phrases pushed into the vocabulary
  sessions_count  int not null default 0,
  completed_at    timestamptz,
  created_at      timestamptz not null default now()
);

create unique index if not exists island_stages_position
  on public.island_stages (island_id, position);

create index if not exists island_stages_scope
  on public.island_stages (user_id, target_language, status);

-- Which island stage a session belonged to, so history stays attributable.
alter table public.conversations add column if not exists stage_id uuid;

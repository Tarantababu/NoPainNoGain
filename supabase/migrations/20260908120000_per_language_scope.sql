-- Scope every learner-owned row to a single target language.
-- Existing rows are backfilled from the language on the learner's profile,
-- so nothing is lost or misfiled.

alter table public.target_vocabulary add column if not exists target_language text;
alter table public.conversations     add column if not exists target_language text;

update public.target_vocabulary tv
   set target_language = p.target_language
  from public.profiles p
 where p.user_id = tv.user_id
   and tv.target_language is null;

update public.conversations c
   set target_language = p.target_language
  from public.profiles p
 where p.user_id = c.user_id
   and c.target_language is null;

-- Anything still unmatched (no profile row) falls back to the app default.
update public.target_vocabulary set target_language = 'German' where target_language is null;
update public.conversations     set target_language = 'German' where target_language is null;

alter table public.target_vocabulary alter column target_language set not null;
alter table public.conversations     alter column target_language set not null;
alter table public.target_vocabulary alter column target_language set default 'German';
alter table public.conversations     alter column target_language set default 'German';

alter table public.profiles alter column target_language set not null;

-- One profile row per (learner, language) instead of one per learner.
alter table public.profiles drop constraint if exists profiles_user_id_key;
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'profiles_user_language_key'
  ) then
    alter table public.profiles
      add constraint profiles_user_language_key unique (user_id, target_language);
  end if;
end $$;

create index if not exists target_vocabulary_scope
  on public.target_vocabulary (user_id, target_language, status);
create index if not exists conversations_scope
  on public.conversations (user_id, target_language, created_at desc);

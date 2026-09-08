-- Multiple learner profiles (max 5), each with completely separate progress,
-- plus the timestamp needed to report daily mastery.

create table if not exists public.learners (
  id text primary key,
  name text not null,
  emoji text not null default '🙂',
  created_at timestamptz not null default now()
);

-- Existing rows are all owned by 'default_user', so seed that as profile one.
insert into public.learners (id, name, emoji)
values ('default_user', 'Me', '🙂')
on conflict (id) do nothing;

-- Hard cap of five profiles, enforced in the database and not only in the UI.
create or replace function public.enforce_learner_limit()
returns trigger
language plpgsql
as $$
begin
  if (select count(*) from public.learners) >= 5 then
    raise exception 'Profile limit reached: a maximum of 5 profiles is allowed';
  end if;
  return new;
end;
$$;

drop trigger if exists learners_limit on public.learners;
create trigger learners_limit
  before insert on public.learners
  for each row execute function public.enforce_learner_limit();

-- When a phrase was mastered, so daily progress can report it.
alter table public.target_vocabulary add column if not exists mastered_at timestamptz;

update public.target_vocabulary
   set mastered_at = created_at
 where status = 'mastered'
   and mastered_at is null;

create index if not exists target_vocabulary_mastered_at
  on public.target_vocabulary (user_id, target_language, mastered_at);

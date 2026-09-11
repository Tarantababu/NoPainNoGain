-- Distinguish single words from multi-word phrases.
-- Words are stored in dictionary form (infinitive; nouns with their article in
-- gendered languages) and are matched against speech differently: a word must
-- appear as its own token, allowing inflection, rather than as a substring.

alter table public.target_vocabulary
  add column if not exists kind text not null default 'phrase';

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'target_vocabulary_kind_check'
  ) then
    alter table public.target_vocabulary
      add constraint target_vocabulary_kind_check check (kind in ('phrase', 'word'));
  end if;
end $$;

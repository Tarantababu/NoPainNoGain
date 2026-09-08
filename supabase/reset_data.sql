-- ============================================================================
-- Fluent Loop — wipe all learner data and start from scratch.
--
-- Deletes every profile, phrase and conversation. The schema itself (tables,
-- indexes, the five-profile trigger) is left completely untouched, so the app
-- keeps working — it just has nothing in it.
--
-- THIS CANNOT BE UNDONE. Take a backup first if you might want the data back.
--
-- Run it in the Supabase SQL editor, or with:
--   psql "$DATABASE_URL" -f supabase/reset_data.sql
-- ============================================================================

begin;

delete from public.target_vocabulary;
delete from public.conversations;
delete from public.profiles;
delete from public.learners;

-- Re-seed the default profile so the app opens on a clean, working state.
-- (Skip this and the app will create it for you on next load.)
insert into public.learners (id, name, emoji)
values ('default_user', 'Me', '🙂')
on conflict (id) do nothing;

commit;

-- Confirm the result.
select 'learners' as table_name, count(*) from public.learners
union all select 'profiles',          count(*) from public.profiles
union all select 'target_vocabulary', count(*) from public.target_vocabulary
union all select 'conversations',     count(*) from public.conversations;

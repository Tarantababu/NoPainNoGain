-- Concrete, transcript-checkable criteria for an island stage's objective.
-- Generated once when the stage becomes current, so they stay fixed and can
-- accumulate across sessions: [{ id, text, met, evidence, missing, met_at }].
-- Once a check is met it stays met; ai_verdict becomes "every check met".
alter table public.island_stages add column if not exists checks jsonb;

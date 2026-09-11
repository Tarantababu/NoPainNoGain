<p align="center">
  <img src="assets/logo-tile.svg" width="76" alt="Fluent Loop" />
</p>

# Fluent Loop

A voice-first language coach in **one HTML file**. You talk out loud for thirty minutes, and the mistakes you make become tomorrow's vocabulary.

**Live: https://tarantababu.github.io/NoPainNoGain/** — hosted on GitHub Pages, redeployed on every push to `main`.

No build step, no bundler, no server. Open `index.html` and it runs: React 18, Babel, Tailwind and the Supabase client all load from CDNs, and your own OpenAI and Supabase credentials are entered in the app and kept in `localStorage`.

---

## What it does

- **Two conversation modes.** Turn-based (tap to speak) or Realtime (open mic, speech-to-speech, cut in whenever you like).
- **Speaks only your target language**, calibrated to a CEFR level you pick.
- **Never corrects you mid-conversation.** Corrections arrive after the session, so the talking stays fluent.
- **Turns your errors into a vocabulary list**, then works those phrases back into later sessions until you have actually used each one three times.
- **Suggests phrases proactively** too, so you are not limited to fixing past mistakes.
- **Keeps every language separate.** Your German level, vocabulary and history never touch your Spanish ones.
- **Up to five learner profiles**, each with completely independent progress.
- **Daily stats and streaks** so you can see the habit forming.
- **Spaced repetition over your saved phrases** — Wordstack's flashcard engine, built in.
- **Language islands** — you pick a subject to own; the AI designs the roadmap that gets you there.
- **Exports your vocabulary** as CSV or plain text, with Turkish translations.

---

## Setup

### 1. Create the Supabase tables

The repo carries the schema as migrations, so the quickest path is:

```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

Or paste this into the Supabase SQL editor (it is also shown inside the app on the setup screen):

```sql
create table if not exists public.learners (
  id text primary key,
  name text not null,
  emoji text not null default '🙂',
  created_at timestamptz not null default now()
);
insert into public.learners (id, name) values ('default_user', 'Me')
  on conflict (id) do nothing;

-- Hard cap of five profiles, enforced in the database and not only in the UI.
create or replace function public.enforce_learner_limit()
returns trigger language plpgsql as $$
begin
  if (select count(*) from public.learners) >= 5 then
    raise exception 'Profile limit reached: a maximum of 5 profiles is allowed';
  end if;
  return new;
end; $$;
drop trigger if exists learners_limit on public.learners;
create trigger learners_limit before insert on public.learners
  for each row execute function public.enforce_learner_limit();

create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  user_id text default 'default_user',
  target_language text not null default 'German',
  current_cefr text default 'B1',
  vocab_injection_mode text default 'adapt_naturally',
  unique (user_id, target_language)
);

create table if not exists public.target_vocabulary (
  id uuid primary key default gen_random_uuid(),
  user_id text default 'default_user',
  target_language text not null default 'German',
  phrase text not null,
  translation text,
  correction_context text,
  times_reviewed int default 0,
  status text default 'learning',
  mastered_at timestamptz,
  created_at timestamptz default now()
);

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  user_id text default 'default_user',
  target_language text not null default 'German',
  topic text not null,
  duration_seconds int,
  transcript jsonb not null,
  feedback jsonb,
  created_at timestamptz default now()
);

create index if not exists target_vocabulary_scope
  on public.target_vocabulary (user_id, target_language, status);
create index if not exists conversations_scope
  on public.conversations (user_id, target_language, created_at desc);
```

Every learner-owned row is keyed by **(user_id, target_language)** — `user_id` is the learner profile. See [Profiles](#profiles) and [Multiple languages](#multiple-languages).

<details>
<summary><strong>Upgrading from the single-language schema?</strong></summary>

If you already have tables without a `target_language` column, run this instead. It backfills existing rows with the language from your old profile, so nothing is lost or misfiled.

```sql
alter table public.target_vocabulary add column if not exists target_language text;
alter table public.conversations   add column if not exists target_language text;

update public.target_vocabulary tv set target_language = p.target_language
  from public.profiles p where p.user_id = tv.user_id and tv.target_language is null;
update public.conversations c set target_language = p.target_language
  from public.profiles p where p.user_id = c.user_id and c.target_language is null;

update public.target_vocabulary set target_language = 'German' where target_language is null;
update public.conversations   set target_language = 'German' where target_language is null;

alter table public.target_vocabulary alter column target_language set not null;
alter table public.conversations   alter column target_language set not null;

alter table public.profiles drop constraint if exists profiles_user_id_key;
alter table public.profiles add constraint profiles_user_language_key
  unique (user_id, target_language);
```

The app detects the old schema and tells you to run this rather than failing obscurely.
</details>

The browser talks to Supabase directly with the **anon** key, so either leave RLS off on these three tables (fine for a single-user tool) or add policies that let `anon` read and write them:

```sql
alter table public.profiles enable row level security;
create policy "anon all" on public.profiles
  for all to anon using (true) with check (true);
-- repeat for target_vocabulary and conversations
```

### 2. Serve the file over localhost or HTTPS

Microphone access requires a secure context. Opening the file with `file://` will not work.

```bash
python3 -m http.server 8777
```

Then visit `http://localhost:8777/index.html`.

### 3. Enter your credentials

On first run the app asks for:

| Field | Notes |
| --- | --- |
| OpenAI API key | Used for transcription, chat, speech and realtime |
| Supabase URL | `https://xxxx.supabase.co` |
| Supabase anon key | The public anon key, not the service role key |
| Target language | 15 options, from German to Mandarin — each gets its own workspace |
| CEFR level | A1 through C2 |
| Vocab injection mode | Adapt Naturally or Force Verbatim |
| Partner voice | Voice used for the spoken replies |

Settings (the gear icon) reopens this screen later, and carries a **Reset this workspace** action at the bottom. It erases the vocabulary, flashcards, review history, sessions and island roadmap for the profile and language you currently have selected — and nothing else. Your other profiles, your other languages, and your level and injection mode all survive it. It asks twice, and shows you what is about to go.

**OpenAI balance** also lives in Settings. OpenAI offers no API for reading your remaining credit, so the app keeps its own ledger: you type in what your billing page shows once, and every call the app makes is priced from the usage OpenAI reports back — tokens for `gpt-4o` and `gpt-realtime` (cached tokens at the cached rate), tokens for `gpt-4o-transcribe` (or minutes if it falls back to `whisper-1`), characters for `tts-1` — and subtracted. It shows *≈ $X left* with a breakdown, turns amber under $2 and red under $0.50, and links straight to OpenAI's billing page for the exact figure. It is an estimate by design: it counts only this app on this device, at list prices checked on 11 Sep 2026 (see `PRICES` in `index.html` if they change). The exact org-wide alternative — the Costs API — needs an admin key, which has no read-only mode and would sit in a browser that loads third-party scripts, so the app deliberately does not use it.

**Test & Save** verifies the OpenAI key, probes the Supabase tables and writes your profile before letting you through. Everything is stored under the `fluentloop.config.v1` key in `localStorage` — nothing is sent anywhere else.

---

## Profiles

Up to **five learner profiles** share one install — useful for a couple, a family, or keeping a serious language apart from a casual one. Tap the profile chip in the dashboard header to switch, rename or create.

Each profile owns its languages, levels, vocabulary, session history and streak. Nothing is shared between them.

The five-profile cap is enforced by a database trigger, not just the UI, so a stray tab or a direct API call cannot exceed it either. Deleting a profile erases that person's vocabulary, sessions and levels in every language — the UI asks twice, and it cannot be undone.

---

## Language islands

A language island, in Boris Shekhtman's sense, is a block of speech you own cold — your job, your city, the argument that keeps coming up. You rehearse it until it is automatic, then deploy it in real conversation.

**You choose the island. The AI designs everything below it.**

Tell it what you want to own ("my work as a backend developer") and two or three sentences about yourself. It returns a roadmap of **ten stages**, each a session's worth of work:

| Field | What it holds |
| --- | --- |
| `objective` | The concrete thing you must be able to say |
| `scenario` | The situation you practise it in |
| `structures` | Grammar to lean on |
| `phrases` | 4–6 chunks, which become vocabulary when you reach the stage |
| `done_when` | An observable test, judged from your transcript |
| `recycles_from` | Earlier stages this one deliberately reuses |

That last field is what makes it a roadmap rather than a themed shuffle: every stage after the first is built to re-fire the phrases from the ones before it. Early stages are the load-bearing ones you need in every conversation; later ones handle disagreeing, telling a story with a point, and questions you did not see coming.

The planner is also fed your **recorded mistakes** from recent sessions, so the roadmap targets what you actually get wrong rather than what was guessed on day one.

### How a stage moves

"Topic of the day" becomes the current stage, and its objective and scenario are written into the session prompt — the partner steers so you have to produce the stage's phrases yourself, without ever mentioning the stage exists.

A stage clears when **both** halves are done:

1. **Every goal is met.** When a stage becomes current, its objective is split into 2–3 concrete goals a judge can verify from a transcript — *"states what the project is for"*, *"mentions a next step"*. Style criteria that transcription cannot see (*"without hesitation"*, *"concisely"*) are ruled out. After each session the judge ticks each goal separately, quoting your words. **Goals accumulate**: once met, a goal stays met, even if a later session doesn't repeat it.
2. **Every phrase is used in 2 separate sessions** — proof you can recall it on another day. (Vocabulary mastery proper is still 3; flashcards handle the long term.)

Both halves are objective, so when they land the island advances by itself — with a proper moment for it, showing what you now own and what is next.

**You can always see where you are:**

- **The dashboard** shows progress *inside* the current stage — *"1/3 goals · 3/5 phrases ready · 57%"* — not just stages completed.
- **During the session**, a strip under the topic lists the goals and the phrases as chips that tick the moment you say them.
- **After the session**, the feedback opens on an **Island** tab: how far the session moved you (*30% → 57%, +27%*), each goal with your quote or a note on what is still missing, and each phrase's progress.

**When a stage drags** — three sessions without clearing — the dashboard offers a **10-minute focused session** aimed only at the goals and phrases still missing. **Skip this stage** remains in the island sheet as an escape hatch.

One island runs per language at a time. Archiving keeps its phrases and history.

---

## Flashcards and spaced repetition

Talking generates vocabulary; SRS makes it stick. Any saved phrase can be **forged** into a card set from the Flashcards panel on the dashboard.

Forging a phrase calls GPT-4o for **six natural example sentences** (idiomatic, varied in tense and register, each containing the phrase — inflected or separated where the language does that) and then records **one mp3 per sentence** with `tts-1`. That set becomes **13 cards**:

| Deck | Cards | What you do |
| --- | --- | --- |
| Reading | 1 | See all six sentences with the phrase highlighted; recall its meaning |
| Listening | 6 | Hear a sentence; recall it, then check the text and translation |
| Speaking | 6 | See the sentence with the phrase blanked out; say it aloud, then shadow the audio |

**Scheduling is Anki-style SM-2**, ported unchanged: learning steps at 1 min and 10 min, graduating to 1 day (4 for Easy), then intervals driven by an ease factor that Again/Hard/Good/Easy move up and down. Lapses drop the card into a 10-minute relearning step. Each rating button shows the interval it will produce before you press it.

Keyboard: **space** reveals the answer, **1–4** rate Again/Hard/Good/Easy, **Esc** leaves the session.

**New cards per day** is capped (20 by default, editable on the dashboard) and counted per language, so studying German does not eat your Spanish budget.

**Anki export** lives in the export sheet: three `.txt` files with `#deck` headers and base64 audio embedded, the Speaking file typed as Cloze. Import them and Anki schedules independently of the in-app queue.

Audio is stored as base64 in Postgres rather than in a storage bucket. That keeps the app to one file with no bucket policies to configure, and it is what makes the Anki export self-contained — at roughly 150–250 KB per phrase, the free tier holds a couple of thousand phrases.

---

## Progress and streaks

The dashboard carries a progress strip; tapping it opens the full view:

- **Current streak** and your best ever. A day counts when you finish at least one session, and today being empty does not break a streak that ran through yesterday — it only ends once you miss a full day.
- **Today** — minutes spoken, sessions, phrases added, phrases mastered.
- **Last 14 days** as a bar chart of minutes per day.
- **All time** — minutes, sessions, phrases learning and mastered, days practised, best streak.

Days are counted on your local calendar, so a session at 23:30 belongs to that evening rather than to the next UTC day. Stats are scoped to the active profile and language, matching the rest of the app.

---

## Multiple languages

Each target language is a **separate workspace**. Switching language switches everything with it:

| Scoped per language | Meaning |
| --- | --- |
| CEFR level | You can be B2 in German and A1 in Spanish at the same time |
| Injection mode | Adapt Naturally for one language, Force Verbatim for another |
| Vocabulary | German phrases never appear in a Spanish session |
| Session history | Stats and the recommended next topic come only from that language |
| Exports | A CSV contains one language, and the filename says which |

Use the dropdown in the dashboard header to switch. Picking a language you have never studied creates its profile automatically at B1, with an empty vocabulary list. The active language is remembered in `localStorage`, so the app reopens where you left off.

Under the hood every row carries `target_language`, and every read and write is filtered by `(user_id, target_language)`. The language a session ran in is pinned when the session ends, so switching mid-analysis cannot misfile the results.

---

## How a session works

Pick a topic (recommended, or your own) and talk for thirty minutes. The countdown is visible, and hitting `00:00` triggers the analysis automatically. You can end early with **End & Analyze** at any point.

### Your mistakes stay in the transcript

Feedback can only catch mistakes the transcriber leaves in, and speech recognisers are trained to produce clean text — `whisper-1` in particular quietly repairs non-native grammar, so *"Gestern ich habe nach Hause gegangen"* could reach the analysis as the correct *"Gestern bin ich nach Hause gegangen"* and never be flagged.

So transcription uses **`gpt-4o-transcribe`**, which follows written instructions, with a **verbatim prompt** in both modes: write exactly what was said, keep every wrong ending, article, gender and word order, keep fillers and false starts, and leave words said in another language untranslated (which is what lets *word gaps* spot them). The analysis is told the transcript is verbatim, so a wrong form counts as a real mistake while fillers never count as grammar errors. Phrase matching looks past fillers, so *"our project, uh, focuses on"* still counts.

No recogniser can guarantee a perfectly verbatim transcript, so **Settings has a transcription check**: read a sentence that contains a deliberate, typical mistake for your language, and the app transcribes that one recording both ways — the old plain `whisper-1` and the verbatim setup — marking each *mistake kept* or *corrected away*. It costs well under a cent and settles the question on your own voice.

If an account can't use `gpt-4o-transcribe`, sessions fall back to `whisper-1` on their own — in live mode too, where an unusable transcriber would otherwise leave the call with no transcript at all.

### Speaking at your level

The CEFR level you set for a language decides how your partner talks, in both modes. Each level has a concrete spec rather than an adjective — sentence and turn length, grammar, vocabulary band, the kind of questions asked, and what to do when you don't understand — and only your level's spec goes into the prompt:

| Level | Sentences | Turn | Voice speed |
| --- | --- | --- | --- |
| A1 | 3–7 words, present tense, yes/no questions | ≤ 15 words | 0.8× |
| A2 | 5–10 words, simple past and future | ≤ 22 words | 0.87× |
| B1 | 8–14 words, simple subordinate clauses | ≤ 35 words | 0.95× |
| B2 | 10–18 words, full everyday range, no corporate jargon | ≤ 45 words | 1.0× |
| C1 | varied and natural, nuance and hedging | ≤ 60 words | 1.05× |
| C2 | fully native, idiom and irony | ≤ 70 words | 1.1× |

The partner is told to stay *at* the level — sounding like a beginners' textbook to a B2 learner counts as a failure too — and not to drift upward to match you: it may reuse a hard word you introduced, but keeps everything around it at your level. Change the level in Settings and the next session follows it. Each language keeps its own level.

### Your partner remembers you

The partner opens **inside the topic you chose** — a line that sets the scene and one concrete question — and is explicitly forbidden from asking what you want to talk about. On an island stage it steps straight into the role-play.

It also knows you. After every session the analysis stores a short summary of what you talked about and any personal facts you mentioned (your job, people, places, plans). The next session loads the last few for that profile and language, so the partner can pick up threads — *"how did the rollback go?"* — and quietly create chances to practise your most frequent mistakes, without ever correcting you out loud. It is told never to invent details it was not given. Memory is scoped exactly like everything else: one profile, one language.

### Turn-based mode

Tap the big button to record, tap again to send.

```
MediaRecorder (webm/opus) → gpt-4o-transcribe (verbatim) → gpt-4o → tts-1 → playback
```

Tapping the button while your partner is talking stops the audio immediately and starts recording you instead.

### Realtime mode

```
mic track → WebRTC → gpt-realtime → audio track → speakers
```

The browser mints an ephemeral client secret at `POST /v1/realtime/client_secrets`, then completes the SDP exchange at `POST /v1/realtime/calls`. Turn taking is handled server-side by voice activity detection with `interrupt_response` enabled, so **you interrupt by simply talking** — there is nothing to tap. The big button becomes mute/unmute. If ephemeral secrets are unavailable on your account, it falls back to the API key that is already in the browser.

Realtime is billed at audio rates, so a full thirty minutes costs noticeably more than turn-based.

Either way the transcript ends up in the same shape, so everything downstream is identical.

---

## After the session

The whole transcript goes to `gpt-4o` with a JSON schema enforced, and the result opens in a bottom sheet with three tabs:

| Tab | Contents |
| --- | --- |
| **Grammar** | Your wording, the correction, and one sentence on why |
| **New Vocab** | Phrases that would have made this exact conversation smoother |
| **Summary** | CEFR feedback, the next topic to attempt, phrases you just mastered |

In the background it also:

- inserts the recommended phrases into `target_vocabulary` as `learning`, skipping anything already saved;
- increments `times_reviewed` for every active phrase you actually used, and flips a phrase to `mastered` at **3 uses**;
- saves the transcript, feedback and duration into `conversations`.

Phrase reuse is detected two ways: a normalized string scan over your own turns, plus the analyser reporting which target phrases you produced. The second signal catches conjugated, declined and split forms that a string scan cannot see — German separable verbs and reflexives, for instance.

---

## Vocabulary

The bar on the dashboard shows every `learning` phrase with its progress toward mastery.

**Add** opens a sheet that does two things:

- **Suggest** — ten multi-word chunks pitched at your CEFR level: collocations, sentence starters, connectors, hedges, reactions, polite formulas. Single words are explicitly excluded. An optional theme narrows the set ("small talk at work"). Phrases you already have are excluded from the prompt and filtered again from the response.
- **Add your own** — type a phrase and an optional meaning.

Both go into the same batch, and everything you add starts at `0/3` uses and gets woven into your next session.

**Export** writes a CSV (Excel-safe, with a BOM) or a plain-text list. Ticking Turkish translates the list with `gpt-4o` at export time and caches the result for the session, so a second export is free.

Turkish is generated on demand rather than stored, because the schema has no column for it. If you would rather have it persisted and reviewable, add a `turkish text` column and write it during analysis.

---

### Single words, when you need them

Most of what the app saves is multi-word — chunks are what make speech fluent. But sometimes the gap is one word: you reached for *receipt* and it wasn't there. So vocabulary entries are either a **phrase** or a **word**.

**Words are saved on evidence, not quota.** After a session the analysis lists single words you *demonstrably* lacked — you switched language for them, talked around them, used the wrong word, asked what one meant, or didn't understand it when your partner said it. It must quote your own words as proof; no quote, no word. An empty list is the normal result of a session that went fine.

Words are stored in **dictionary form** — infinitive for verbs, and nouns *with their article* in gendered languages (`die Quittung`, `la cuenta`), because the gender has to be learned with the noun. The feedback sheet shows each one under *Words you were missing* with the sentence where you needed it, and they carry a **word** badge everywhere.

Suggestions and island stages may each include **at most two** single words, and only ones their situation can't be discussed without.

**Counting a word's use** works differently from a phrase. A word has to appear as a token of its own, so *Hund* is not "used" inside *Hundefutter*, and *receipt* is not used in *received*. Inflection is accepted — the whole word plus a short ending (*Quittung → Quittungen*, *borrow → borrowed*), or a verb's stem after its infinitive ending drops (*verstehen → verstehe*, *hablar → hablamos*). Articles are ignored when matching, per language: *die Quittung* counts in *eine Quittung*, while English *a lot* stays a two-word phrase. Irregular forms (*gehen → ging*) are left to the analyser's own judgement. Your partner is told which targets are words, and to make you produce them rather than hand them over.

## Injection modes

| Mode | Behaviour |
| --- | --- |
| **Adapt Naturally** | Your partner conjugates, declines and reorders a target phrase so it fits the sentence |
| **Force Verbatim** | The phrase appears exactly as saved, character for character, and the sentence is built around it |

Adapt Naturally sounds like a real conversation. Force Verbatim is better when you want to drill a fixed form.

---

## Tech notes

- **Single file.** All markup, styles, components and API plumbing live in `index.html`.
- **Babel is pinned to `7.26.4`.** Unpinned `@babel/standalone` now resolves to v8, which defaults JSX to the automatic runtime and emits an `import` statement — that breaks an in-browser transform with `Cannot use import statement outside a module`.
- **Models:** `gpt-4o-transcribe` (with `whisper-1` as fallback), `gpt-4o`, `tts-1`, `gpt-realtime`.
- **Mobile-first dark UI**, built with the Tailwind CDN build.
- **Logo** lives in `assets/`: `logo.svg` (the mark, inheriting `currentColor`), `logo-tile.svg` (the app icon on
  indigo), and `logo-wordmark.svg` (horizontal lockup). The favicon is the same mark inlined as a data URI, so the
  app stays a single file.

---

## Limitations

- No authentication. Profiles separate people's *data*, but not their *access*: anyone who opens the app can switch to any profile and see it.
- Your API key sits in the browser. Fine for personal use on your own machine, not for a shared deployment.
- Duplicate phrases are caught by exact normalized match, so a near-variant of an existing phrase can still be saved as its own row.
- The Tailwind and Babel CDN builds print production warnings in the console. Harmless here, but this is not a production deployment pattern.

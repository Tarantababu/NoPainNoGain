# Fluent Loop

A voice-first language coach in **one HTML file**. You talk out loud for thirty minutes, and the mistakes you make become tomorrow's vocabulary.

No build step, no bundler, no server. Open `index.html` and it runs: React 18, Babel, Tailwind and the Supabase client all load from CDNs, and your own OpenAI and Supabase credentials are entered in the app and kept in `localStorage`.

---

## What it does

- **Two conversation modes.** Turn-based (tap to speak) or Realtime (open mic, speech-to-speech, cut in whenever you like).
- **Speaks only your target language**, calibrated to a CEFR level you pick.
- **Never corrects you mid-conversation.** Corrections arrive after the session, so the talking stays fluent.
- **Turns your errors into a vocabulary list**, then works those phrases back into later sessions until you have actually used each one three times.
- **Suggests phrases proactively** too, so you are not limited to fixing past mistakes.
- **Exports your vocabulary** as CSV or plain text, with Turkish translations.

---

## Setup

### 1. Create the Supabase tables

Run this in the Supabase SQL editor (it is also shown inside the app on the setup screen):

```sql
create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  user_id text unique default 'default_user',
  target_language text default 'German',
  current_cefr text default 'B1',
  vocab_injection_mode text default 'adapt_naturally'
);

create table if not exists public.target_vocabulary (
  id uuid primary key default gen_random_uuid(),
  user_id text default 'default_user',
  phrase text not null,
  translation text,
  correction_context text,
  times_reviewed int default 0,
  status text default 'learning',
  created_at timestamptz default now()
);

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  user_id text default 'default_user',
  topic text not null,
  duration_seconds int,
  transcript jsonb not null,
  feedback jsonb,
  created_at timestamptz default now()
);
```

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
| Target language | 15 options, from German to Mandarin |
| CEFR level | A1 through C2 |
| Vocab injection mode | Adapt Naturally or Force Verbatim |
| Partner voice | Voice used for the spoken replies |

**Test & Save** verifies the OpenAI key, probes the Supabase tables and writes your profile before letting you through. Everything is stored under the `fluentloop.config.v1` key in `localStorage` — nothing is sent anywhere else.

---

## How a session works

Pick a topic (recommended, or your own) and talk for thirty minutes. The countdown is visible, and hitting `00:00` triggers the analysis automatically. You can end early with **End & Analyze** at any point.

### Turn-based mode

Tap the big button to record, tap again to send.

```
MediaRecorder (webm/opus) → whisper-1 → gpt-4o → tts-1 → playback
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
- **Models:** `whisper-1`, `gpt-4o`, `tts-1`, `gpt-realtime`.
- **Mobile-first dark UI**, built with the Tailwind CDN build.

---

## Limitations

- Single user. Every row is written against `user_id = 'default_user'`; there is no auth.
- Your API key sits in the browser. Fine for personal use on your own machine, not for a shared deployment.
- Duplicate phrases are caught by exact normalized match, so a near-variant of an existing phrase can still be saved as its own row.
- The Tailwind and Babel CDN builds print production warnings in the console. Harmless here, but this is not a production deployment pattern.

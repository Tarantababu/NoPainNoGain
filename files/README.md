# Wordstack — flashcard forge + built-in SRS + sync

Type a word → GPT writes 6 natural sentences + TTS audio → review them right in the app
with Anki-style spaced repetition → export to Anki whenever you want (the export files are
identical to the original app's).

Everything is saved on-device (IndexedDB) and, once Supabase is connected, synced
automatically between your computer and your iPhone — words, audio, review schedule, and
review history.

```
index.html            the whole app
sw.js                 service worker (offline / installed-app support)
manifest.webmanifest  PWA manifest
icon-192/512.png      app icons
supabase-setup.sql    database setup — safe to re-run any time
```

---

# ▶ Upgrading an existing install (v1 → v2)

You already have this running and synced, so do these three things in order.

### 1. Run the SQL again (adds one table)

Supabase dashboard → **SQL Editor** → paste all of `supabase-setup.sql` → **Run**.

The whole file is idempotent (`create table if not exists`, `drop policy if exists`), so
re-running it changes nothing you already have. It adds the new `revlog` table that the
statistics dashboard reads from. **Skipping this step means sync will report an error**
once you answer a card, because the app will try to push review-log rows to a table that
doesn't exist yet. Your words and schedule stay safe either way.

### 2. Redeploy the folder

Replace the old files on Vercel / GitHub Pages with these. `sw.js` has been bumped to
cache version `wordstack-v2`, which is what forces installed devices to pick up the new
interface rather than serving the cached old one.

### 3. Refresh both devices

- **Desktop:** hard-reload once (Ctrl/Cmd + Shift + R).
- **iPhone:** open the installed app, swipe it closed from the app switcher, reopen. If it
  still looks old, open the URL in Safari once, then reopen the home-screen app.

Nothing needs re-entering: your API key, Supabase URL/key and login all stay where they
were. Your existing review schedule carries over untouched. The statistics dashboard
starts from zero history, because reviews you did before this update were never logged —
it fills in from your next session onward.

---

# What's new in v2

**Per-language study.** Each target language now has its own queue and its own daily
new-card budget. When you have more than one language, chips appear on the home screen
(All / English / German / …); pick one and the counts, the study session, and the
statistics all scope to it. Your choice is remembered per device. "New cards/day" in
Settings applies to each language separately, so 20/day with two languages means up to
20 English + 20 German — not 20 split between them.

**Settings moved behind the gear icon.** The whole keys/languages/sync panel now lives in
a full-screen sheet opened from ⚙ in the header. Everything in it is stored on the
device, so it's a one-time thing: the API key, Supabase URL and anon key are restored on
every visit, and Supabase keeps you signed in. The sheet only opens by itself on a truly
fresh device (no key, no words).

**Statistics dashboard.** The 📊 icon in the header opens: current day streak, reviews
today with recall accuracy, all-time reviews, words forged, a 14-day activity chart, a
card-maturity bar (new / learning / young / mature), and a per-language table showing
words, cards due, and total reviews. It's computed from a review log that syncs across
devices, so reviewing on the phone shows up in the desktop stats.

**Export is a header icon.** The big export panel is gone — the ⬇ icon in the header
downloads all three deck files, with a toast for progress. The files themselves are
completely unchanged.

**Study-first home screen.** The page now opens on a single dark hero: what's ready right
now, in one number, with one big yellow button. The word library is collapsed underneath
and expands when you want it.

---

# First-time setup (new device or fresh install)

## 1. Create the Supabase backend (~5 minutes, free tier is plenty)

1. https://supabase.com → free account → **New project**.
2. **SQL Editor** → paste all of `supabase-setup.sql` → **Run**. This creates the tables,
   their security rules, and a private `audio` storage bucket.
3. Optional: **Authentication → Sign In / Up → Email** → turn OFF "Confirm email", so
   creating your account works instantly without a confirmation mail.
4. From **Project Settings → API**, copy the **Project URL** and the **anon / public key**.

The anon key is designed to be public — row-level security means each account can only
ever read and write its own rows and its own audio folder.

## 2. Put the app online

Service workers and "Add to Home Screen" need HTTPS, so host the folder somewhere:
**Vercel** (drag & drop the unzipped folder at vercel.com → Add New → Project) or
**GitHub Pages** (push the folder → Settings → Pages → deploy from branch).

## 3. First run

Open your URL → ⚙ **Settings** → paste the OpenAI key, the Supabase URL and anon key,
then enter an email + password → **Create account** → **Sign in**. The header dot turns
green. Add a word and it's generated, saved, and pushed to your project.

## 4. iPhone

Open the same URL in **Safari** → sign in with the same email/password → **Share → Add to
Home Screen**. Studying works offline; generating new words needs internet.

---

# How the pieces behave

- **Study queue** — Anki-style: learning steps 1 min → 10 min, graduate to 1 day, then
  SM-2 intervals with Again/Hard/Good/Easy. Each word contributes 13 cards
  (1 reading + 6 listening + 6 speaking).
- **Sync** — automatic after every change, on reconnect, and when the app regains focus;
  the dot in the header forces one when tapped. Conflicts resolve last-write-wins. The
  review log is append-only, so history never fights itself between devices.
- **Audio** — stored on-device and in your private bucket. On a new device it downloads on
  demand (when studied, previewed, or exported), then stays cached offline.
- **Anki export** — unchanged: three `.txt` files with `#deck` headers and embedded base64
  audio; import the Speaking file with the **Cloze** note type. The in-app schedule and
  Anki's scheduler stay independent of each other.
- **Deleting a word** removes it and its review history from every device (the MP3s remain
  in the storage bucket; prune old folders under Supabase → Storage if you ever care).
- **Statistics** count a "day" by your local calendar day, so a late-evening session lands
  on the day it felt like.

# Costs

Supabase free tier: 500 MB database + 1 GB storage — roughly 3,000+ words. OpenAI usage is
unchanged (~$0.01–0.02 per word for generation + TTS).

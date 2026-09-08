{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fswiss\fcharset0 Helvetica-Bold;}
{\colortbl;\red255\green255\blue255;\red24\green24\blue24;\red255\green255\blue255;\red16\green16\blue16;
\red0\green0\blue0;\red83\green209\blue96;\red64\green139\blue255;\red0\green0\blue0;\red239\green236\blue236;
\red252\green125\blue209;}
{\*\expandedcolortbl;;\cssrgb\c12157\c12157\c12157;\cssrgb\c100000\c100000\c100000;\cssrgb\c7843\c7843\c7843;
\cssrgb\c0\c0\c0;\cssrgb\c37647\c83922\c45098;\cssrgb\c30980\c62745\c100000;\cssrgb\c0\c0\c0\c54902;\cssrgb\c94902\c94118\c94118;
\cssrgb\c100000\c58824\c85490;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid1\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid1}
{\list\listtemplateid2\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid101\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{circle\}}{\leveltext\leveltemplateid102\'01\uc0\u9702 ;}{\levelnumbers;}\fi-360\li1440\lin1440 }{\listname ;}\listid2}
{\list\listtemplateid3\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid201\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{circle\}}{\leveltext\leveltemplateid202\'01\uc0\u9702 ;}{\levelnumbers;}\fi-360\li1440\lin1440 }{\listname ;}\listid3}
{\list\listtemplateid4\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid301\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{circle\}}{\leveltext\leveltemplateid302\'01\uc0\u9702 ;}{\levelnumbers;}\fi-360\li1440\lin1440 }{\listname ;}\listid4}
{\list\listtemplateid5\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid401\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid5}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}{\listoverride\listid2\listoverridecount0\ls2}{\listoverride\listid3\listoverridecount0\ls3}{\listoverride\listid4\listoverridecount0\ls4}{\listoverride\listid5\listoverridecount0\ls5}}
\paperw11900\paperh16840\margl1440\margr1440\vieww38200\viewh22040\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs24 \cf2 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Copy and paste this prompt directly into 
\f1\b Claude Code
\f0\b0  to generate the complete, production-ready single-file application.\
\
\pard\pardeftab720\partightenfactor0
\cf3 \cb4 \strokec3 Markdown\cb1 \
\pard\pardeftab720\qc\partightenfactor0

\fs48 \cf0 \strokec5 \
\
\
\
\pard\pardeftab720\partightenfactor0

\fs28 \cf3 \cb4 \strokec3 # Role & Task\
You are an expert Principal Full-Stack Engineer specializing in single-file React applications, Tailwind CSS, OpenAI APIs, and Supabase.\
Your task is to build a fully functional, self-contained, single-file web application in \cf6 \strokec6 `index.html`\cf3 \strokec3  for continuous language learning through voice conversations.\
\
---\
\
## 1. Technical Stack Constraints\
\pard\pardeftab720\partightenfactor0
\cf7 \strokec7 -\cf3 \strokec3  
\f1\b **Single File Target:**
\f0\b0  The entire application (HTML structure, Tailwind CSS styling, React 18, Babel compiler, Supabase JS client, and custom API/audio pipelines) MUST be contained within a single \cf6 \strokec6 `index.html`\cf3 \strokec3  file.\
\cf7 \strokec7 -\cf3 \strokec3  
\f1\b **CDN Libraries Required:**
\f0\b0 \
\cf7 \strokec7   -\cf3 \strokec3  React 18 (\cf6 \strokec6 `react.development.js`\cf3 \strokec3 , \cf6 \strokec6 `react-dom.development.js`\cf3 \strokec3 )\
\cf7 \strokec7   -\cf3 \strokec3  Babel Standalone (\cf6 \strokec6 `babel.min.js`\cf3 \strokec3 )\
\cf7 \strokec7   -\cf3 \strokec3  Tailwind CSS (\cf6 \strokec6 `cdn.tailwindcss.com`\cf3 \strokec3 )\
\cf7 \strokec7   -\cf3 \strokec3  Supabase JS Client (\cf6 \strokec6 `@supabase/supabase-js@2`\cf3 \strokec3 )\
\cf7 \strokec7 -\cf3 \strokec3  
\f1\b **No Mocking or Placeholders:**
\f0\b0  Provide complete, runnable Javascript/React code. Every fetch request, state transition, and audio recording handler must be fully written out.\
\
---\
\
## 2. Supabase Database Architecture\
Assume the following SQL schema exists in Supabase (and include this snippet as a comment at the top of the script):\
\
\pard\pardeftab720\partightenfactor0
\cf6 \strokec6 ```sql\
create table if not exists public.profiles (\
  id uuid primary key default gen_random_uuid(),\
  user_id text unique default 'default_user',\
  target_language text default 'German',\
  current_cefr text default 'B1',\
  vocab_injection_mode text default 'adapt_naturally' -- 'adapt_naturally' | 'force_verbatim'\
);\
\
create table if not exists public.target_vocabulary (\
  id uuid primary key default gen_random_uuid(),\
  user_id text default 'default_user',\
  phrase text not null,\
  translation text,\
  correction_context text,\
  times_reviewed int default 0,\
  status text default 'learning', -- 'learning' | 'mastered'\
  created_at timestamp with time zone default now()\
);\
\
create table if not exists public.conversations (\
  id uuid primary key default gen_random_uuid(),\
  user_id text default 'default_user',\
  topic text not null,\
  duration_seconds int,\
  transcript jsonb not null,\
  feedback jsonb,\
  created_at timestamp with time zone default now()\
);\
\pard\pardeftab720\partightenfactor0

\f1\b\fs36 \cf2 \cb1 \strokec2 3. Core Feature Specifications\
\pard\pardeftab720\partightenfactor0

\fs28 \cf2 A. Configuration & Setup Screen\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls1\ilvl0
\f0\b0\fs24 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Input fields for 
\fs30 \cf8 \cb9 \strokec8 OpenAI API Key
\fs24 \cf2 \cb1 \strokec2 , 
\fs30 \cf8 \cb9 \strokec8 Supabase URL
\fs24 \cf2 \cb1 \strokec2 , and 
\fs30 \cf8 \cb9 \strokec8 Supabase Anon Key
\fs24 \cf2 \cb1 \strokec2  (stored persistently in 
\fs30 \cf8 \cb9 \strokec8 localStorage
\fs24 \cf2 \cb1 \strokec2 ).\uc0\u8232 \
\ls1\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Configuration options: 
\fs30 \cf8 \cb9 \strokec8 Target Language
\fs24 \cf2 \cb1 \strokec2  (e.g., German, Spanish, French), 
\fs30 \cf8 \cb9 \strokec8 CEFR Level
\fs24 \cf2 \cb1 \strokec2  (A1 to C2), and 
\fs30 \cf8 \cb9 \strokec8 Vocab Injection Mode
\fs24 \cf2 \cb1 \strokec2  (
\fs30 \cf8 \cb9 \strokec8 Adapt Naturally
\fs24 \cf2 \cb1 \strokec2  vs 
\fs30 \cf8 \cb9 \strokec8 Force Verbatim
\fs24 \cf2 \cb1 \strokec2 ).\uc0\u8232 \
\ls1\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Test/Save button that initializes the Supabase client and redirects to the main Dashboard.\uc0\u8232 \
\pard\pardeftab720\partightenfactor0

\f1\b\fs28 \cf2 B. Daily Dashboard\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls2\ilvl0
\fs24 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Active Vocabulary Bar:
\f0\b0  Fetches and displays phrases from 
\fs30 \cf8 \cb9 \strokec8 target_vocabulary
\fs24 \cf2 \cb1 \strokec2  where 
\fs30 \cf8 \cb9 \strokec8 status = 'learning'
\fs24 \cf2 \cb1 \strokec2 . Shows review count (e.g., 
\fs30 \cf8 \cb9 \strokec8 2/3 uses
\fs24 \cf2 \cb1 \strokec2 ).\uc0\u8232 \
\ls2\ilvl0
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Topic Selection:
\f0\b0 \uc0\u8232 \
\pard\tx940\tx1440\pardeftab720\li1440\fi-1440\partightenfactor0
\ls2\ilvl1\cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Provides a 
\f1\b Recommended Topic of the Day
\f0\b0  generated dynamically from previous feedback or target vocabulary.\uc0\u8232 \
\ls2\ilvl1\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Allows custom topic entry via text input.\uc0\u8232 \
\ls2\ilvl1\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 "Start Session" button triggers the Active Conversation View.\uc0\u8232 \
\pard\pardeftab720\partightenfactor0

\f1\b\fs28 \cf2 C. Active Conversation Screen & Audio Engine\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls3\ilvl0
\fs24 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Turn-Based Voice Loop:
\f0\b0 \uc0\u8232 \
\pard\tx940\tx1440\pardeftab720\li1440\fi-1440\partightenfactor0
\ls3\ilvl1
\f1\b \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 User Recording:
\f0\b0  Uses browser 
\fs30 \cf8 \cb9 \strokec8 MediaRecorder
\fs24 \cf2 \cb1 \strokec2  API to capture microphone audio as WebM/Ogg. Tapping the large central button toggles recording ON/OFF.\uc0\u8232 \
\ls3\ilvl1
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Speech-to-Text:
\f0\b0  Sends audio blob to OpenAI Whisper API (
\fs30 \cf8 \cb9 \strokec8 https://api.openai.com/v1/audio/transcriptions
\fs24 \cf2 \cb1 \strokec2  with model 
\fs30 \cf8 \cb9 \strokec8 whisper-1
\fs24 \cf2 \cb1 \strokec2 ).\uc0\u8232 \
\ls3\ilvl1
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Conversational Intelligence:
\f0\b0  Sends transcript history + System Prompt to OpenAI Chat Completions (
\fs30 \cf8 \cb9 \strokec8 https://api.openai.com/v1/chat/completions
\fs24 \cf2 \cb1 \strokec2  with model 
\fs30 \cf8 \cb9 \strokec8 gpt-4o
\fs24 \cf2 \cb1 \strokec2 ).\uc0\u8232 \
\ls3\ilvl1
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Text-to-Speech:
\f0\b0  Takes the assistant text response and converts it to audio using OpenAI TTS API (
\fs30 \cf8 \cb9 \strokec8 https://api.openai.com/v1/audio/speech
\fs24 \cf2 \cb1 \strokec2  with model 
\fs30 \cf8 \cb9 \strokec8 tts-1
\fs24 \cf2 \cb1 \strokec2 , voice 
\fs30 \cf8 \cb9 \strokec8 alloy
\fs24 \cf2 \cb1 \strokec2 ). Plays back automatically via 
\fs30 \cf8 \cb9 \strokec8 HTMLAudioElement
\fs24 \cf2 \cb1 \strokec2 .\uc0\u8232 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls3\ilvl0
\f1\b \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Interruption Logic:
\f0\b0  Tapping the microphone button while the AI audio is playing MUST immediately pause and cancel the audio playback (
\fs30 \cf8 \cb9 \strokec8 audio.pause(); audio.currentTime = 0;
\fs24 \cf2 \cb1 \strokec2 ).\uc0\u8232 \
\ls3\ilvl0
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 System Prompt Construction:
\f0\b0 \uc0\u8232 \
\pard\tx940\tx1440\pardeftab720\li1440\fi-1440\partightenfactor0
\ls3\ilvl1\cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 System prompt must explicitly instruct 
\fs30 \cf8 \cb9 \strokec8 gpt-4o
\fs24 \cf2 \cb1 \strokec2  to stay in character, adjust vocabulary to the user's selected CEFR level, and inject active 
\fs30 \cf8 \cb9 \strokec8 learning
\fs24 \cf2 \cb1 \strokec2  phrases from the user's database according to the 
\fs30 \cf8 \cb9 \strokec8 vocab_injection_mode
\fs24 \cf2 \cb1 \strokec2 .\uc0\u8232 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls3\ilvl0
\f1\b \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 30-Minute Countdown Timer:
\f0\b0 \uc0\u8232 \
\pard\tx940\tx1440\pardeftab720\li1440\fi-1440\partightenfactor0
\ls3\ilvl1\cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 A visible countdown timer starting at 30:00.\uc0\u8232 \
\ls3\ilvl1\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Auto-triggers "End & Analyze Session" when timer hits 00:00.\uc0\u8232 \
\pard\pardeftab720\partightenfactor0

\f1\b\fs28 \cf2 D. Automated Post-Session Analysis (Bottom-Sheet Drawer)\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls4\ilvl0
\f0\b0\fs24 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Triggered on manual "End Session" click or timer expiration.\uc0\u8232 \
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Sends the entire transcript to 
\fs30 \cf8 \cb9 \strokec8 gpt-4o
\fs24 \cf2 \cb1 \strokec2  requesting structured JSON enforcement:\uc0\u8232 \u8232 \cf3 \cb4 \strokec3 JSON\cb1 \uc0\u8232 
\fs48 \cf0 \strokec5 \uc0\u8232 \u8232 \u8232 \u8232 
\fs24 \cf3 \strokec3 \uc0\u8232 
\fs28 \cb4 \{\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls4\ilvl0\cf3 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3   \cf10 \strokec10 "grammar_mistakes"\cf3 \strokec3 : [\
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3     \{ \cf10 \strokec10 "original"\cf3 \strokec3 : \cf6 \strokec6 "string"\cf3 \strokec3 , \cf10 \strokec10 "correction"\cf3 \strokec3 : \cf6 \strokec6 "string"\cf3 \strokec3 , \cf10 \strokec10 "explanation"\cf3 \strokec3 : \cf6 \strokec6 "string"\cf3 \strokec3  \}\
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3   ],\
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3   \cf10 \strokec10 "recommended_phrases"\cf3 \strokec3 : [\
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3     \{ \cf10 \strokec10 "phrase"\cf3 \strokec3 : \cf6 \strokec6 "string"\cf3 \strokec3 , \cf10 \strokec10 "translation"\cf3 \strokec3 : \cf6 \strokec6 "string"\cf3 \strokec3 , \cf10 \strokec10 "context"\cf3 \strokec3 : \cf6 \strokec6 "string"\cf3 \strokec3  \}\
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3   ],\
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3   \cf10 \strokec10 "next_topic_recommendation"\cf3 \strokec3 : \cf6 \strokec6 "string"\cf3 \strokec3 ,\
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3   \cf10 \strokec10 "cefr_level_feedback"\cf3 \strokec3 : \cf6 \strokec6 "string"\cf3 \strokec3 \
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3 \}\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls4\ilvl0\cf3 \cb1 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec3 \uc0\u8232 
\fs24 \cf2 \strokec2 \uc0\u8232 \u8232 \cb4 \uc0\u8232 \cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls4\ilvl0
\f1\b \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Database Automated Updates:
\f0\b0 \uc0\u8232 \
\pard\tx940\tx1440\pardeftab720\li1440\fi-1440\partightenfactor0
\ls4\ilvl1
\f1\b \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Insert Vocab:
\f0\b0  Saves newly recommended phrases into 
\fs30 \cf8 \cb9 \strokec8 target_vocabulary
\fs24 \cf2 \cb1 \strokec2  with 
\fs30 \cf8 \cb9 \strokec8 status = 'learning'
\fs24 \cf2 \cb1 \strokec2 .\uc0\u8232 \
\ls4\ilvl1
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Vocab Progression Engine:
\f0\b0  Scans transcript for existing 
\fs30 \cf8 \cb9 \strokec8 learning
\fs24 \cf2 \cb1 \strokec2  phrases used by the user. Increments 
\fs30 \cf8 \cb9 \strokec8 times_reviewed
\fs24 \cf2 \cb1 \strokec2 . If 
\fs30 \cf8 \cb9 \strokec8 times_reviewed >= 3
\fs24 \cf2 \cb1 \strokec2 , updates 
\fs30 \cf8 \cb9 \strokec8 status
\fs24 \cf2 \cb1 \strokec2  to 
\fs30 \cf8 \cb9 \strokec8 'mastered'
\fs24 \cf2 \cb1 \strokec2 .\uc0\u8232 \
\ls4\ilvl1
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u9702 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Save Session:
\f0\b0  Inserts conversation transcript and feedback into 
\fs30 \cf8 \cb9 \strokec8 conversations
\fs24 \cf2 \cb1 \strokec2 .\uc0\u8232 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls4\ilvl0
\f1\b \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 UI:
\f0\b0  Slide-up bottom sheet with tabs for "Grammar Corrections", "New Vocabulary", and "Overall Summary".\uc0\u8232 \
\pard\pardeftab720\partightenfactor0

\f1\b\fs36 \cf2 4. UI/UX & Styling Guidelines\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls5\ilvl0
\f0\b0\fs24 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Mobile-first, sleek dark theme using Tailwind CSS (
\fs30 \cf8 \cb9 \strokec8 bg-gray-900
\fs24 \cf2 \cb1 \strokec2 , 
\fs30 \cf8 \cb9 \strokec8 text-white
\fs24 \cf2 \cb1 \strokec2 , 
\fs30 \cf8 \cb9 \strokec8 bg-gray-800
\fs24 \cf2 \cb1 \strokec2  cards).\uc0\u8232 \
\ls5\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Minimalist, highly responsive layout with clear visual audio states (Recording = pulsing red ring, Processing = spinner/status text, Playing = active indicator).\uc0\u8232 \
\ls5\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Smooth bottom-sheet overlay with backdrop backdrop-blur for session feedback.\uc0\u8232 \
\pard\pardeftab720\partightenfactor0
\cf2 Please output the COMPLETE 
\fs30 \cf8 \cb9 \strokec8 index.html
\fs24 \cf2 \cb1 \strokec2  file code without truncating any JS functions or CSS.\
}
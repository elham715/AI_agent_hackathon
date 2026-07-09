# Problem Statement

> **Source:** Email from Md. Takrim Farhan Elham (elham715) — 9 July 2026
> **Subject:** Problem Statement - Agentic AI Hackathon
> **Recipient:** Tasnim Ashraf, Director of Technical Affairs, IUT Computer Society

---

## The Four Tracks

### 1. Autonomous Travel Concierge for Bangladesh
**Why it matters:** Foreign tourists struggle with Bangladesh's fragmented transport system (buses, trains, flights, launches, CNGs, Pathao/Uber) and lack of real-time English-language information. Local freelancers/remote workers need the same help plus visa/tax/connectivity info.

**Build:** An AI agent that:
- Plans multi-leg trips (Dhaka → Sylhet → Srimangal, etc.)
- Recommends transport modes and ETAs using real-time/local data
- Provides Bangla/English support
- Suggests budget hotels, halal food, attractions
- Helps with visa, tax (foreign-source income), and SIM/eSIM setup
- Sends alerts for transport disruptions (strikes, weather)

**Judging focus:** UX, real-time data integration, accurate local info, multi-agent collaboration.

---

### 2. Smart Agro-Advisor (Smallholder Farmers)
**Why it matters:** Smallholder farmers in Bangladesh lose 30–40% of crops to pests, weather, and outdated practices. Information is scattered across Bengali YouTube channels, Krishidesh, BARI/DAE websites, and Krishi Call Centers.

**Build:** A voice + chat agent that:
- Diagnoses crop diseases from images (rice blast, mango hopper, etc.)
- Recommends treatments (chemical + organic) in plain Bangla
- Pulls weather + soil data from local APIs
- Suggests optimal planting/harvest windows for BD zones
- Delivers via mobile-first UI (Bangla voice input — many farmers are low-literacy)

**Judging focus:** Real-world utility, multimodal input (voice + image), accessibility for low-literacy users.

---

### 3. Disaster Response & Relief Coordination
**Why it matters:** During floods/cyclones (e.g., Cyclone Remal, 2024), Bangladesh's Cyclone Preparedness Programme (CPP) and Disaster Management Ministry rely on phone calls and scattered WhatsApp groups. Information silos delay response.

**Build:** A multi-agent coordination system that:
- Monitors BMD, FFWC, and news/social signals for early warnings
- Routes alerts to affected zones in Bangla (multilingual)
- Coordinates volunteers (registered + spontaneous) by location/skill
- Tracks shelter capacity, relief inventory, medical needs
- Connects with volunteer matching platforms (e.g., a Bangladesh version of VolunteerHub)
- Maintains a public dashboard

**Judging focus:** Realistic deployment feasibility, social impact, multi-agent architecture.

---

### 4. Local SMB Automation Toolkit
**Why it matters:** Bangladesh has ~7.8M SMBs (78 lakh) — most run on paper ledgers or basic POS. They lack inventory tracking, customer follow-up, and digital marketing. Tools like Rokomari, Chaldal, and 10 Minute School are vertical-specific but no general "agentic backoffice" exists.

**Build:** A plug-and-play toolkit (modular agents) where shop owners:
- Activate only the agents they need (inventory, invoice, marketing, customer follow-up)
- Use Bangla + voice interface (target: shop owners who can't type)
- Integrate bKash/Nagad for payments
- Work on low-end Android phones (target: NGO field agents)

**Judging focus:** Realistic adoption path, modularity, business viability, voice-first UX.

---

## Evaluation Criteria (per email)

| Criterion | Weight | Description |
|-----------|--------|-------------|
| **Innovation & Creativity** | 20% | Originality of the agentic solution |
| **Technical Implementation** | 25% | Use of LLMs, agents, APIs, MCP, automation frameworks |
| **Bangladesh Context** | 15% | Local relevance, language, data sources |
| **Impact & Feasibility** | 20% | Social/business impact, can it deploy tomorrow |
| **Presentation & Demo** | 20% | Live demo quality, clear storytelling |

---

## Hackathon Logistics

- **Dates:** 10 AM, 24 July - 10 AM, 25 July, 2026 (24 hours)
- **Teams:** 1–3 undergraduate students
- **Cross-university teams:** Allowed
- **Registration:** https://forms.gle/CLpwSLBnZHQuysof9 (deadline: 20 July)
- **First round:** Idea presentation (problem, solution, plan, tech stack)
- **Final round:** 24-hour on-site hack
- **Final venue:** IUT Gazipur campus
- **Team limit:** 12 teams total
- **Contact:** Tasnim Ashraf (01608873666), Tajwar (01730416386)
- **Queries:** iutcs@iut-dhaka.edu

---

## Submission Requirements

1. **Public GitHub repository** — code created on hackathon day only
2. **3-minute demo video** — feature walkthrough with voice narration
3. **Live demo at venue** — judges will run your prototype

**Submission deadline:** 25 July, 10 AM

---

## Recommended Project Match (vs. our tested stack)

We already verified these APIs work:
- ✓ Gemini `gemini-embedding-001` (3072-dim embeddings)
- ✓ Gemini `gemini-flash-latest` (generation)
- ✓ OpenRouter `google/gemini-2.5-flash-lite` (free tier)

**Best fit for our stack:**

| Track | Fit | Why |
|-------|-----|-----|
| #1 Travel Concierge | ⭐⭐⭐⭐ | LLM + search + multilingual — perfect for agents |
| #2 Smart Agro | ⭐⭐⭐⭐⭐ | Image + voice + Bangla — our Gemini embeddings ideal for crop disease KB |
| #3 Disaster Response | ⭐⭐⭐ | Multi-agent, but needs heavy real-time data |
| #4 SMB Automation | ⭐⭐⭐ | Possible but very ambitious in 24h |

**Top picks:** Track #1 (Travel) or Track #2 (Agro) — both are achievable MVPs that score high on Bangladesh Context (15%), Impact (20%), and Demo (20%).
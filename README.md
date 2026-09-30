# Comeback Mode: a product concept for SuperKalam

A working prototype and write-up exploring one question: what should happen on the day a UPSC aspirant breaks their study streak?

- **Write-up (problem, evidence, solution, metrics):** [PRD.md](PRD.md)
- **Prototype:** `index.html`, a single self-contained page
- **Review dataset and SQL analysis:** `data/`
- **PostHog queries for the prototype test:** `analytics/posthog_queries.sql`

## Run it locally

Open `index.html` in a browser. Nothing to install.

## Deploy on Vercel (same way as the Xeno prototype)

1. Create a new GitHub repository and upload every file in this folder, keeping the folder structure.
2. In Vercel, choose **Add New → Project**, import the repository, and deploy with the default settings. There is no build step.
3. Copy the live link into `PRD.md` (the "Prototype" line at the top).

## Connect PostHog

1. Create a free PostHog account and project.
2. Copy the project API key. It starts with `phc_` and is safe to use in a web page.
3. In `index.html`, find `CONFIG` near the top of the script and paste the key into `POSTHOG_KEY`. If your project is in the EU cloud, change `POSTHOG_HOST` to `https://eu.i.posthog.com`.
4. Set `PRD_URL` to the GitHub link of `PRD.md` so testers and reviewers can open the write-up.
5. Commit the change; Vercel redeploys automatically.
6. Open the live link once and check that events appear in PostHog under **Activity**.

## Run the test

- Send the link to 20–30 UPSC aspirants. Each person gets one of the two versions at random and keeps it on repeat visits.
- Ask them to go through the flow once, without using the version switch (switched runs are tagged `manual` and excluded).
- After a few days, run the queries in `analytics/posthog_queries.sql` in PostHog's SQL editor and add the results to section 8 of the PRD.

## Re-run the review analysis

```bash
cd data
sqlite3 < analysis.sql
```

## How this was built

- **Research:** public app-store listings, reviews and the SuperKalam website.
- **Review coding:** each review was paraphrased and tagged by theme; the analysis is written in SQL.
- **Prototype:** vibe-coded with AI assistance (Claude), in plain HTML, CSS and JavaScript, instrumented with PostHog.

# Data Sources

Where and how to gather validation data. Every research agent and standalone research skill loads this file.

## Google Trends

**How to access:** Web search for "[keyword] site:trends.google.com" or "[keyword] google trends"
**What to extract:**
- Trajectory: rising, stable, or declining over past 12 months
- Seasonal patterns (e.g., tax software spikes in Q1)
- Related rising queries — these reveal adjacent opportunities and emerging terminology
- Geographic concentration — is demand global or regional?
**How to cite:** Include the search term and note the trend direction. Example: "Google Trends shows 'SaaS security' rising 40% year-over-year."

## Reddit

**How to access:** Web search for "site:reddit.com [keywords]" or search specific subreddits.
**Target subreddits:**
- General: r/SaaS, r/startups, r/Entrepreneur, r/smallbusiness, r/indiehackers, r/sideproject
- Tech: r/webdev, r/programming, r/devops, r/machinelearning (domain-specific)
- Always add domain-specific subs relevant to the idea
**What to look for:**
- Complaint posts: "I'm frustrated with...", "Why doesn't anyone build..."
- Tool recommendation requests: "What do you use for...", "Best tool for..."
- "I wish there was..." posts — direct demand signals
- Upvote counts and comment volume as proxy for resonance
**How to cite:** Include the subreddit, post title, approximate upvote count, and URL.

## Hacker News

**How to access:** Web search for "site:news.ycombinator.com [keywords]" or use hn.algolia.com/api/v1/search?query=[keywords]
**What to look for:**
- Ask HN posts about the problem — strongest signal (people actively seeking solutions)
- Show HN posts from competitors — indicates market activity
- Comment threads discussing the problem — look for recurring themes
- Upvote counts indicate community resonance
**How to cite:** Include post title, point count, and HN URL.

## Product Hunt

**How to access:** Web search for "site:producthunt.com [keywords]"
**What to look for:**
- Recent launches in the space (last 12 months = active market)
- Upvote counts and comment sentiment on competitor launches
- Maker responses to feedback — reveals competitor gaps
- "Alternative to [X]" launches — indicates market dissatisfaction
**How to cite:** Include product name, launch date, upvote count, and URL.

## G2 / Capterra

**How to access:** Web search for "[problem] software G2" or "[category] Capterra"
**What to look for:**
- Category listings — how many products exist?
- Review ratings and review counts per competitor
- Common complaints in negative reviews — these are gap opportunities
- Feature comparison gaps across the category
**How to cite:** Include the category, number of listed products, and URL.

## GitHub

**How to access:** Web search for "github awesome [topic]" or search github.com directly
**What to look for:**
- awesome-[topic] lists — indicates developer interest and ecosystem maturity
- Star counts on related open source projects (proxy for developer demand)
- Issue counts and recent activity — active issues mean active users with problems
- "Help wanted" or "good first issue" tags — indicates project health
**How to cite:** Include repo name, star count, and URL.

## Google Search

**How to access:** Standard web search
**What to search:**
- "[problem] tool" / "[problem] SaaS" / "[problem] app" — find competitors
- "[problem] alternative to [known competitor]" — find dissatisfied users
- "[problem] pricing" — understand willingness to pay
- "[problem] open source" — find free alternatives (competition for paid tools)
- "how to [problem]" — find people with unmet needs
**What to extract:** Number of results, top competitors, pricing pages, comparison articles
**How to cite:** Include the search query and relevant URLs found.

## Citation Rules

- Every claim must have a source URL or specific search query
- "Based on Reddit discussions" is not a citation. "r/SaaS post 'Why is X so hard' (342 upvotes, 2025-11)" is a citation.
- If a source is behind a paywall or unavailable, note that and use alternative sources
- If no data is available for a source, say so explicitly — don't skip it silently

# Scoring Rubric

The IdeaProbe validation framework scores business ideas across 5 dimensions. Each dimension is scored 0-20. Total score determines the verdict.

## Dimensions

### 1. Demand Signals (0-20)

Measures evidence that people actively have the problem your idea solves.

**What to look for:**
- Search volume for problem-related keywords (Google Trends trajectory)
- Reddit/HN posts where people describe the problem or ask for solutions
- "How do I...", "Is there a tool that...", "I wish there was..." queries
- Job postings that reference the problem (proxy for industry activity)

**Score bands:**
- 16-20 **Strong**: High search volume, 50+ community posts, rising trend, people actively seeking solutions
- 11-15 **Moderate**: Steady search volume, 10-50 posts, problem acknowledged but not urgent
- 6-10 **Weak**: Low search volume, <10 posts, mostly tangential mentions
- 0-5 **None**: No measurable demand signals found

### 2. Competitor Landscape (0-20)

Measures the state of existing solutions and whether gaps exist.

**What to look for:**
- Direct competitors (Google: "[problem] tool/app/SaaS")
- Competitor pricing models and price points
- Product Hunt launches in the space (recent = active market)
- G2/Capterra category listings and review complaints
- GitHub awesome-lists and open source alternatives

**Score bands:**
- 16-20 **Strong**: Clear gaps in a crowded market — competitors exist but underserve a segment, miss a pricing tier, or have consistent complaints about a specific weakness
- 11-15 **Moderate**: Some competitors, differentiation is possible but requires effort
- 6-10 **Weak**: Saturated market — 15+ competitors with strong leaders, hard to differentiate
- 0-5 **Red flag**: Zero competitors usually means no market, not an untapped opportunity

### 3. Willingness to Pay (0-20)

Measures evidence that the target audience will spend money on this.

**What to look for:**
- Are competitors charging? What's the price range?
- Are people on Reddit/HN frustrated with free alternatives (signal they'd pay for better)?
- Does the target audience have budget authority (enterprise vs consumer)?
- Are there adjacent paid products in the same workflow?

**Score bands:**
- 16-20 **Strong**: Competitors charge $20+/month, users complain about free tool limitations, audience has clear budget
- 11-15 **Moderate**: Some paid competitors, unclear if target segment specifically will pay
- 6-10 **Weak**: Market expects free, low price points (<$10/month), or no pricing data available
- 0-5 **Unlikely**: Consumer market with strong free alternatives, no evidence of spending

### 4. Build Feasibility (0-20)

Measures whether a solo dev or small team can build a useful MVP quickly.

**What to look for:**
- Can an MVP be built in 2-4 weeks?
- Are required APIs and data sources available and affordable?
- Does it need regulatory compliance (HIPAA, SOC2, PCI)?
- Does it require partnerships, marketplace approvals, or cold-start network effects?
- Is the core technical challenge well-understood or novel?

**Score bands:**
- 16-20 **Strong**: Standard web stack, available APIs, no regulatory hurdles, 2-week MVP realistic
- 11-15 **Moderate**: Some integration complexity, 4-week MVP, may need one paid API
- 6-10 **Weak**: Significant technical hurdles, regulatory requirements, or dependency on third-party approvals
- 0-5 **Blocked**: Requires major infrastructure, regulatory compliance, partnerships, or >8 weeks to MVP

### 5. Founder Fit (0-20)

Measures how well the builder's background positions them to succeed with this specific idea.

**What to look for:**
- Does the builder have domain knowledge or direct access to it?
- Do they have distribution (audience, professional network, community presence)?
- Can they be the first user of the product?
- Do they understand the customer's language and workflow?

**Score bands:**
- 16-20 **Strong**: Deep domain expertise, existing audience in the target market, will be own first user
- 11-15 **Moderate**: Related experience, some network access, can learn the domain quickly
- 6-10 **Weak**: No domain experience, no distribution, would need to cold-start everything
- 0-5 **No fit**: Completely outside expertise, no plausible path to the target audience

## Verdict Thresholds

Total score = sum of 5 dimensions (0-100).

| Score | Verdict | Meaning |
|-------|---------|---------|
| 80-100 | **GO** | Strong signals across the board. Start building. |
| 60-79 | **EXPLORE** | Promising but needs deeper validation on weak areas before committing. |
| 40-59 | **PIVOT** | Core problem exists but approach needs rethinking. Change the solution, audience, or model. |
| 0-39 | **STOP** | Weak demand or fundamental blockers. Move to next idea. |

## Scoring Rules

- Every score must be justified with specific data. "Feels like moderate demand" is not a justification.
- When data is unavailable for a dimension, score conservatively (lower) and note the gap.
- No single dimension determines the verdict — a 20/20 in Demand Signals with 2/20 in Build Feasibility is still a 60s-range EXPLORE, not a GO.
- Founder Fit is scored from the user's profile if available, or by asking the user directly.

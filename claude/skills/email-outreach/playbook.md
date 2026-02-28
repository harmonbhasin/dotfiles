# Email Outreach Playbook

Detailed reference for personalization, sequences, deliverability, and funnel math.

## Personalization Strategies

Go beyond "I saw your LinkedIn." The best personalization feels like you actually care.

**Uncommon commonalities** — shared alma mater, former employer, hometown, hobby:
> "Hey Sarah — saw you were at Stripe before starting Finley. I was on the Connect team in 2019. Small world."

**Research-based compliments** — reference their blog, talk, or product decision:
> "Your post on migrating off Kafka was the best thing I read last month. We're solving a related problem."

**Deep-cut personal details** — podcast appearances, tweets, side projects:
> "Heard you on Lenny's pod talking about PLG onboarding. That 'aha moment' framework stuck with me."

**Industry-specific insight** — show you understand their world:
> "Noticed you just raised a Series A — congrats. Most fintech teams hit a compliance bottleneck around this stage."

## Credibility Builders

Pick ONE that's most relevant to the recipient:

| Type | Example |
|------|---------|
| YC batch | "We're in the current YC batch (W25)" |
| Relevant role | "I spent 4 years running infrastructure at Datadog" |
| Customer proof | "We help 30+ Series A fintech companies with X" |
| Shared connection | "Alex Chen suggested I reach out" |
| Data as value | "We analyzed 10K onboarding flows — your category converts 2x below median" |

## Subject Line Formulas

Keep under 50 characters. Avoid spam triggers (FREE, URGENT, all caps).

| Pattern | Example |
|---------|---------|
| Value prop | "Cut your hosting costs in half" |
| Shared identity | "Fellow YC founder (W25) — quick question" |
| Curiosity | "[First Name], noticed something about [product]" |
| Mutual connection | "Alex Chen suggested we connect" |
| Specific insight | "Your onboarding drop-off at step 3" |
| SMYKM "+" format | "Switzerland + Le Dip Cheeseburger + Apollo" | See [smykm.md](smykm.md) |

## Follow-Up Sequence

3-5 emails total. Each must add NEW value — never "just bumping this."

| Email | Timing | Approach |
|-------|--------|----------|
| 1 | Day 0 | Core pitch (email anatomy formula) |
| 2 | Day 3-4 | New angle: share a relevant case study or data point |
| 3 | Day 7-8 | Offer value: free audit, useful report, or intro |
| 4 | Day 14 | Social proof: new customer win, press mention |
| 5 | Day 21 | Break-up email: "Should I close the loop on this?" |

> **For SMYKM-style outreach** to high-value targets, see the alternative sequence timing in [smykm.md](smykm.md) (Thu/Fri send, <48hr follow-up, LinkedIn connection request instead of InMail).

**Break-up email example:**
> "Hey [Name] — I know you're busy. If this isn't a priority right now, totally get it. Should I check back in a few months, or close the loop? Either way, no hard feelings."

## Offering Value Before Selling

"Do things that don't scale" — offer genuine help to earn a reply.

- **Free audit:** Run a security scan, SEO analysis, or onboarding review for their product
- **Lunch & Learn:** Offer a 20-min session on your area of expertise for their team
- **Useful data:** Share benchmarks, research, or analysis relevant to their role
- **Warm intro:** Connect them with someone valuable (not you — someone else)
- **Content:** Send a relevant article, template, or tool they'd actually use

## Deliverability Essentials

Bad deliverability kills campaigns before anyone reads your email.

| Step | Action |
|------|--------|
| Separate domain | Buy a variant (e.g., tryharvest.com for harvest.com) — never risk your main domain |
| SPF record | Add to DNS: authorizes your email servers |
| DKIM record | Add to DNS: cryptographically signs your emails |
| DMARC policy | Add to DNS: tells receivers how to handle failures |
| Warm up | Send 10-20 emails/day for 2-3 weeks, gradually increase. Use Mailwarm or similar |
| Volume cap | Max ~50 cold emails/day per mailbox. Use multiple mailboxes to scale |
| Monitor | Track open rates (>50% good), bounce rates (<3%), spam reports (<0.1%) |

## Funnel Math

Work backwards from your goal. Use YOUR actual numbers, not dream conversions.

```
Goal:           1 new customer / week
Close rate:     25% of demos → customer
Demo rate:      20% of replies → demo
Reply rate:     5-10% of emails → reply
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Emails needed:  ~200-400 / week
```

Benchmark: ~250 personalized emails/week is sustainable for founder-led sales. Above that, you need automation or help.

## Recommended Tools

| Category | Tools |
|----------|-------|
| Prospecting | Apollo.io, Hunter.io, LinkedIn Sales Navigator |
| CRM | Close.io, HubSpot, Pipedrive |
| Email automation | Lemlist, Mixmax, Instantly |
| Email client | Superhuman (read receipts, templates) |
| Deliverability | Mailwarm, Warmbox |
| Verification | ZeroBounce, NeverBounce (clean lists before sending) |

# Vendor Review Plugin for Claude Code

A Claude Code plugin that conducts comprehensive third-party vendor security and risk assessments. It spawns parallel research agents to investigate a vendor across ten risk dimensions, scores each on a 1–5 scale using a weighted rubric, and generates a timestamped markdown report suitable for PDF export.

## What It Does

When you run `/vendor-review`, the plugin:

1. **Researches the vendor** by deploying 9 parallel agents that WebFetch the vendor's website and WebSearch across public sources — trust centers, privacy policies, compliance databases, breach records, financial filings, sanctions lists, AI governance disclosures, and reputational data.
2. **Scores 10 risk dimensions** using a structured rubric with cited evidence for every score.
3. **Generates a professional report** with an executive summary, detailed scorecard, findings, risk factors, and recommended mitigations.

### Assessment Dimensions

| Dimension            | Weight | What It Covers                                                  |
|----------------------|--------|-----------------------------------------------------------------|
| Security Posture     | 15%    | Published security practices, certifications, vuln management   |
| Privacy Practices    | 12%    | Privacy policy, DPA, GDPR/CCPA compliance                      |
| Compliance           | 12%    | SOC 2/3, ISO 27001, HIPAA, PCI DSS, FedRAMP                    |
| Breach History       | 12%    | Public breaches, incident response track record                 |
| AI Risk              | 10%    | AI governance, model transparency, bias, EU AI Act / NIST       |
| Export Control Risk  | 8%     | ITAR, EAR, OFAC sanctions, BIS Entity List, jurisdictions       |
| Financial Health     | 8%     | Revenue, funding, going-concern risk                            |
| Reputational Risk    | 8%     | D&B, BBB, lawsuits, regulatory actions                          |
| Leadership Stability | 5%     | Executive tenure, governance, key-person risk                   |
| Transparency         | 10%    | Trust center, status page, audit availability                   |

### Risk Ratings

| Score       | Rating         | Recommendation             |
|-------------|----------------|----------------------------|
| 4.5 – 5.0  | Minimal Risk   | Approve                    |
| 3.5 – 4.4  | Low Risk       | Approve with standard terms|
| 2.5 – 3.4  | Moderate Risk  | Conditional approval       |
| 1.5 – 2.4  | High Risk      | Discourage                 |
| 1.0 – 1.4  | Critical Risk  | Do Not Approve             |

## Requirements

This plugin is built for **Claude Code** — Anthropic's CLI agent for software engineering. It is not compatible with regular Claude (claude.ai web/app), Claude for Slack, or Claude mobile. The plugin relies on Claude Code's agent spawning, WebFetch, WebSearch, and file system access — none of which exist in other Claude interfaces.

### What You Need

- **Claude Code** installed and authenticated ([installation guide](https://docs.anthropic.com/en/docs/claude-code))
- **Claude Code plan** with access to Agent, WebFetch, and WebSearch tools (Pro, Team, or Enterprise)
- **pandoc** (optional, for automatic PDF generation) — install via `brew install pandoc` (macOS) or your package manager
- **xelatex** (optional, for higher-quality PDF output) — install via `brew install --cask mactex` or `tlmgr install xelatex`

### How It Works in Claude Code

1. The plugin registers as a **skill** — a slash command that Claude Code discovers automatically from `.claude/skills/vendor-review/SKILL.md`
2. When you invoke `/vendor-review <url>`, Claude Code reads the SKILL.md instructions and follows them
3. The skill spawns **9 parallel research agents** — each is a separate Claude Code subagent that runs WebFetch and WebSearch independently
4. After all agents report back, the main session synthesizes findings, scores dimensions, and generates the report
5. The report is written locally, converted to PDF, and optionally delivered to a client directory

A typical assessment takes 2–5 minutes depending on the vendor's size and the amount of publicly available information.

## Installation

### Local Use (Single Machine)

Clone the repo into your Claude Code skills directory:

```bash
mkdir -p ~/.claude/skills
git clone git@github.com:Konda-Security/vendor-review-plugin.git ~/.claude/skills/vendor-review
```

Alternatively, symlink from wherever you cloned it:

```bash
git clone git@github.com:Konda-Security/vendor-review-plugin.git ~/path/to/vendor-review-plugin
ln -s ~/path/to/vendor-review-plugin/.claude/skills/vendor-review ~/.claude/skills/vendor-review
```

### Project-Level Use

To make the plugin available only within a specific project, clone or copy the `.claude/skills/vendor-review` directory into that project's `.claude/skills/` folder:

```bash
cd your-project
mkdir -p .claude/skills
cp -r /path/to/vendor-review-plugin/.claude/skills/vendor-review .claude/skills/vendor-review
```

Or add this repo as a git submodule:

```bash
cd your-project
git submodule add git@github.com:Konda-Security/vendor-review-plugin.git .claude/plugins/vendor-review
```

### Verify Installation

Start a new Claude Code session and type `/vendor-review` — it should appear in the skill list. You can also check with `/help` to see available commands.

## Usage

```
/vendor-review <vendor-url-or-company-name>
```

### Examples

```
/vendor-review https://www.datadog.com
/vendor-review Snowflake
/vendor-review https://www.crowdstrike.com
```

The plugin will:
1. **Ask which client** this review is for and where to deliver the report
2. Run 9 research agents in parallel (takes 2–5 minutes depending on the vendor)
3. Generate both markdown and PDF reports
4. Copy reports to the client's delivery directory
5. Update the client's `approved-services.md` tracker (if one exists)
6. Display the executive summary and scorecard in the conversation

For subsequent reviews in the same session, you can say "same client" to skip the client context step.

### Multi-Client Workflow

The plugin is designed for consultants and security teams managing vendor reviews across multiple clients or projects. Each client gets their own delivery directory and approved-services tracker:

```
~/clients/
├── acme-corp/
│   └── security/vendor-review/
│       ├── approved-services.md      # Auto-maintained by the plugin
│       └── reviews/
│           ├── datadog-2026-08-21.md
│           └── datadog-2026-08-21.pdf
└── other-client/
    └── security/vendor-review/
        ├── approved-services.md
        └── reviews/
            └── ...
```

If a client doesn't have an `approved-services.md` yet, the plugin offers to create one from a built-in template.

### Manual PDF Conversion

If pandoc is not installed or automatic PDF generation fails, you can convert manually:

```bash
pandoc reports/vendor-name-2026-08-21.md \
  -o reports/vendor-name-2026-08-21.pdf \
  --pdf-engine=xelatex \
  -V geometry:margin=1in \
  -V fontsize=11pt

# Or open the markdown in any viewer that supports PDF export
# (VS Code + Markdown PDF extension, Marked 2, etc.)
```

## Project Structure

```
vendor-review-plugin/
├── README.md                          # This file
├── CLAUDE.md                          # Claude Code project context
├── .gitignore
├── .claude-plugin/
│   └── plugin.json                    # Marketplace manifest
├── reports/                           # Generated reports (gitignored)
│   └── .gitkeep
└── .claude/
    ├── settings.json                  # Auto-allows WebFetch/WebSearch
    └── skills/
        └── vendor-review/
            ├── SKILL.md               # Main skill — orchestration logic
            └── references/
                ├── scoring.md         # Scoring methodology and rubric
                ├── report-template.md # Markdown report template
                └── approved-services-template.md  # Client tracker template
```

### Key Files

- **`SKILL.md`** — The core of the plugin. Defines the client context workflow, agent prompts, research methodology, synthesis logic, report generation, and client delivery instructions. This is what Claude Code executes when you invoke `/vendor-review`.
- **`references/scoring.md`** — The weighted scoring rubric. Edit this to change dimension weights, add dimensions, or modify the 1–5 scoring criteria.
- **`references/report-template.md`** — The markdown template for generated reports. Edit this to change report structure, add sections, or modify formatting.
- **`references/approved-services-template.md`** — Template for client approved-services trackers. Created automatically for new clients.
- **`.claude/settings.json`** — Pre-approves WebFetch and WebSearch across all domains so research agents don't trigger per-domain permission prompts.

## Customization

### Changing Dimension Weights

Edit `references/scoring.md` and update the weights in the dimensions table. Weights must total 100%. Then update the corresponding scorecard table in `references/report-template.md` to match.

### Adding a Dimension

1. Add the dimension to the weights table in `references/scoring.md`
2. Add a dimension-specific rubric in `references/scoring.md` (see AI Risk and Export Control Risk for examples)
3. Add a scorecard row and detailed findings section in `references/report-template.md`
4. Add a research agent in `SKILL.md` with appropriate WebSearch/WebFetch instructions
5. Add the dimension to the scoring list in the Synthesis Phase of `SKILL.md`

### Changing the Report Format

Edit `references/report-template.md`. The template uses standard markdown with tables. Keep the scorecard table structure intact — the synthesis phase references it.

### Changing Research Depth

Each agent's research instructions are in `SKILL.md` under the "Research Phase" section. You can add or remove WebSearch queries, adjust what each agent looks for, or add entirely new agents.

## Contributing

### Submitting Changes

1. Fork the repository on GitHub
2. Create a feature branch:
   ```bash
   git checkout -b feature/add-supply-chain-dimension
   ```
3. Make your changes
4. Test by running `/vendor-review` against a known vendor and verifying the output
5. Commit with a descriptive message:
   ```bash
   git commit -m "Add supply chain risk dimension with SBOM analysis"
   ```
6. Push and open a pull request:
   ```bash
   git push origin feature/add-supply-chain-dimension
   gh pr create --title "Add supply chain risk dimension" --body "..."
   ```

### What Makes a Good Contribution

- **New dimensions** — with rubric, template section, and research agent
- **Better search queries** — more targeted WebSearch queries that surface better evidence
- **Template improvements** — clearer report structure, better tables, additional context
- **Scoring refinements** — improved rubric criteria based on real-world assessment experience

### Testing Changes

There are no automated tests — the plugin is a set of prompt instructions. To test:

1. Run `/vendor-review` against a well-known vendor (e.g., a major cloud provider with extensive public security documentation)
2. Verify all dimensions are scored with cited evidence
3. Check that the report follows the template structure
4. Confirm the overall score math is correct (weighted average)
5. Read the executive summary — would a non-technical executive understand it?

## Limitations

- Based on **publicly available information only** — no access to internal controls, vendor questionnaire responses, or confidential reports
- **Point-in-time assessment** — reflects what is publicly visible on the assessment date, not continuous monitoring
- Does not include **penetration testing** or technical vulnerability assessment
- **Private company financial data** is limited to public signals (funding rounds, employee trends, customer logos)
- **Sanctions screening** uses web search, not direct OFAC/BIS API access — results should be verified against authoritative databases for compliance decisions
- **AI risk assessment** depends on vendor disclosure — vendors that use AI without public acknowledgment will score as "Unable to Assess" rather than receiving a low score

## License

Copyright Konda Security. All rights reserved.

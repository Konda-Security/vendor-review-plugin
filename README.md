# Konda Security Third Party Risk Management for Claude Code

`tprm` is a Claude Code plugin for third party risk management. Its `vendor-review` skill conducts comprehensive vendor security and risk assessments. It spawns parallel research agents to investigate a vendor across ten risk dimensions, scores each on a 1–5 scale using a weighted rubric, and generates a timestamped markdown report suitable for PDF export.

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

1. The plugin registers as a **skill** — a slash command that Claude Code discovers from `skills/vendor-review/SKILL.md` when the plugin is installed from the marketplace or loaded with `claude --plugin-dir /path/to/vendor-review-plugin`
2. When you invoke `/vendor-review <url>`, Claude Code reads the SKILL.md instructions and follows them
3. The skill spawns **9 parallel research agents** — each is a separate Claude Code subagent that runs WebFetch and WebSearch independently
4. After all agents report back, the main session synthesizes findings, scores dimensions, and generates the report
5. The report is written locally, converted to PDF, and optionally delivered to a client directory

A typical assessment takes 2–5 minutes depending on the vendor's size and the amount of publicly available information.

### Permissions

The skill pre-approves a narrow set of tools in its `allowed-tools` frontmatter:

| Pre-approved | Why |
|---|---|
| `WebFetch`, `WebSearch`, `Agent` | Research and parallel research agents |
| `Read` of the skill's own directory | Scoring rubric and report templates, which sit outside your working directory when the plugin is installed |
| `Edit` under `./reports/` | Writing the report |
| `scripts/make-pdf.sh` | PDF generation with fixed pandoc options, instead of pandoc itself, whose `--filter` flags can run arbitrary programs |

Everything else, such as copying reports to a client directory or updating `approved-services.md`, goes through your normal permission prompts. Claude Code clears a skill's pre-approvals when you send your next message, so after you answer the client questions, the research phase also follows your own permission settings. To avoid a prompt for every vendor domain, add `WebFetch` and `WebSearch` to `permissions.allow` in your settings.

## Installation

### From the Konda Security Marketplace (Recommended)

In a Claude Code session, add the marketplace and install the plugin:

```
/plugin marketplace add https://kondasecurity.com/claude/marketplace.json
/plugin install tprm@konda-security
```

Or do both in one step (Claude Code 2.1.275 or later):

```
/plugin install tprm --marketplace https://kondasecurity.com/claude/marketplace.json
```

The same commands work from your shell as `claude plugin marketplace add ...` and `claude plugin install ...`. Start a new session (or run `/reload-plugins`) after installing.

### Sharing With a Project Team

To register the plugin for everyone who works in a repository, run these once from the repository root and commit the `.claude/settings.json` they write:

```bash
claude plugin marketplace add https://kondasecurity.com/claude/marketplace.json --scope project
claude plugin install tprm@konda-security --scope project
```

Or copy the skill directly into that project's `.claude/skills/` folder:

```bash
cd your-project
mkdir -p .claude/skills
cp -r /path/to/vendor-review-plugin/skills/vendor-review .claude/skills/vendor-review
```

### From a Local Clone

Clone the repo and load it as a plugin when you start Claude Code:

```bash
git clone git@github.com:Konda-Security/vendor-review-plugin.git ~/path/to/vendor-review-plugin
claude --plugin-dir ~/path/to/vendor-review-plugin
```

To make the skill available in every session without the flag, symlink it into your personal skills directory:

```bash
mkdir -p ~/.claude/skills
ln -s ~/path/to/vendor-review-plugin/skills/vendor-review ~/.claude/skills/vendor-review
```

### Updating

Marketplace installs are cached and only change when the plugin's version changes. To pick up a new release, run `/plugin marketplace update konda-security` in a session, or `claude plugin update tprm@konda-security` from your shell. To receive releases automatically, open `/plugin`, go to **Marketplaces**, select `konda-security`, and choose **Enable auto-update**.

### Verify Installation

Start a new Claude Code session and type `/vendor-review`. A marketplace or `--plugin-dir` install lists the skill as `/tprm:vendor-review`, because plugin skills carry the plugin name as a prefix; a copied or symlinked skill lists as `/vendor-review`. From your shell, `claude plugin details tprm` should show `Skills (1)  vendor-review`.

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

If automatic PDF generation fails, install pandoc and a PDF engine, then run the bundled script from the directory that contains `reports/`:

```bash
/path/to/vendor-review-plugin/skills/vendor-review/scripts/make-pdf.sh reports/vendor-name-2026-08-21.md
```

The script writes `reports/vendor-name-2026-08-21.pdf`, trying xelatex, then pdflatex, then wkhtmltopdf. It disables raw TeX and HTML in the markdown, so text in a report can't pull local files into the PDF. You can also open the markdown in any viewer that supports PDF export (VS Code with the Markdown PDF extension, Marked 2, etc.).

## Project Structure

```
vendor-review-plugin/
├── README.md                          # This file
├── LICENSE                            # MIT License
├── CLAUDE.md                          # Claude Code project context
├── .gitignore
├── .claude-plugin/
│   └── plugin.json                    # Marketplace manifest
├── skills/
│   └── vendor-review/
│       ├── SKILL.md                   # Main skill — orchestration logic
│       ├── scripts/
│       │   └── make-pdf.sh            # Markdown-to-PDF with fixed pandoc options
│       └── references/
│           ├── scoring.md             # Scoring methodology and rubric
│           ├── report-template.md     # Markdown report template
│           └── approved-services-template.md  # Client tracker template
├── reports/                           # Generated reports (gitignored)
│   └── .gitkeep
└── .claude/
    ├── settings.json                  # Auto-allows WebFetch/WebSearch
    └── skills/
        └── vendor-review -> ../../skills/vendor-review  # Symlink for in-repo use
```

### Key Files

- **`SKILL.md`** — The core of the plugin. Defines the client context workflow, agent prompts, research methodology, synthesis logic, report generation, and client delivery instructions. This is what Claude Code executes when you invoke `/vendor-review`.
- **`references/scoring.md`** — The weighted scoring rubric. Edit this to change dimension weights, add dimensions, or modify the 1–5 scoring criteria.
- **`references/report-template.md`** — The markdown template for generated reports. Edit this to change report structure, add sections, or modify formatting.
- **`references/approved-services-template.md`** — Template for client approved-services trackers. Created automatically for new clients.
- **`scripts/make-pdf.sh`** — Converts a report under `./reports/` to PDF. The skill pre-approves this script rather than pandoc, so keep any new pandoc options inside it.
- **`.claude/settings.json`** — Pre-approves WebFetch and WebSearch across all domains so research agents don't trigger per-domain permission prompts. It applies only to sessions started inside this repository; a marketplace install does not carry it, so add `WebFetch` and `WebSearch` to `permissions.allow` in your own settings if research agents prompt for each domain.

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

### Releasing

Bump `version` in `.claude-plugin/plugin.json` with every change you want users to receive. Marketplace installs stay on their cached copy until the version string changes, so a merged change without a version bump never reaches them.

The marketplace catalog lives in the [Konda-Security/www](https://github.com/Konda-Security/www) repo at `static/claude/marketplace.json` and tracks this repo's `main` branch. A release is a merge to `main` with a bumped version; the catalog only needs editing when the plugin's name, description, or source changes.

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

Released under the [MIT License](LICENSE).

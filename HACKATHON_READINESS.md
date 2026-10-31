# Hackathon readiness: Qazaq Loc QA

## What the project delivers

`locqa` is a Python CLI for quality checks on Flutter ARB localization files. It compares a source locale with a target locale, emits JSON and HTML findings, supports Kazakh and Uzbek checks, and provides a review/apply workflow so proposed edits can be separated from human-approved edits.

The supplied case handout lists these issue types: `untranslated`, `same_as_source`, `placeholder_mismatch`, `plural_mismatch`, `glossary_violation`, `length_overflow`, `machine_translation_suspect`, `inconsistent_term`, `suffix_harmony`, `orthography`, and `wrong_language`.

## Evidence currently available

The saved case run reports:

- Kazakh: 132 findings in 130 keys, with 59 high and 73 medium severity findings; 229 lower-confidence findings are suppressed by the default threshold.
- Uzbek: 60 findings in the bonus run.
- Synthetic evaluation: recall 0.90 on 100 injected examples. This is an optimistic self-check, not a measured score on the organizers' hidden errors.
- Human review: 0 findings/terms reviewed by a native Kazakh speaker. Proposed edits marked `x-reviewed: false` are drafts and must not be presented as verified translations.
- Flutter: `flutter gen-l10n` was not run locally for the case data. A CI job is configured to compile the bundled example ARB files.

The full output and limitations are documented in [METHODOLOGY.md](METHODOLOGY.md). The case handout available to this project describes the data and error taxonomy but does not include a complete scoring rubric or organizer answer key.

## Reproduce a safe demo

The committed examples are small synthetic ARB files. They contain no partner localization dataset.

```bash
bash scripts/demo.sh
```

The script writes reports and a seeded sample under `/tmp`, first checking the clean example and then detecting three injected issues. It does not modify the source ARB files.

For the full case-data run, follow [README.md](README.md) and keep the provided data out of Git. To prepare final deliverables after reviewer decisions:

```bash
scripts/run_pipeline.sh apply
bash scripts/check_gen_l10n.sh data intl_ru.arb
```

The final `apply` step only marks edits reviewed when the review CSV contains a reviewer decision and reviewer identity. Do not submit a draft as a human-verified translation.

## Submission checklist

- [ ] Compare report JSON fields, issue names, severity values, and ARB review metadata with the organizer's exact schema.
- [ ] Have a qualified Kazakh reviewer decide every submitted translation change, or clearly submit changes as unreviewed drafts if allowed.
- [ ] Resolve or document the glossary terms still marked `draft` and the open terminology questions in `METHODOLOGY.md`.
- [ ] Run `locqa validate` and the real `flutter gen-l10n` command on the exact final ARB files.
- [ ] Report precision from adjudicated `accept`, `edit`, and `keep` decisions separately from synthetic recall.
- [ ] Include the limitations of the synthetic benchmark and avoid claiming it represents hidden-set accuracy.
- [ ] Keep partner ARB files, review exports, and reports containing partner strings out of this public repository.

## Why the workflow is conservative

Localization heuristics can identify likely defects but cannot establish that a Kazakh sentence is idiomatic. `x-reviewed` records whether a person actually checked a change. This distinction keeps automated evidence useful without implying language validation that did not happen.

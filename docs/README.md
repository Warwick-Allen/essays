# GitHub Pages Site

This directory contains the GitHub Pages site for Warwick Allen's essays:

https://warwick-allen.github.io/essays/

The site is built with Jekyll and is intended to be deployed from the `main`
branch using the `/docs` folder.

## Key Files

- `_config.yml` contains the GitHub Pages and Markdown configuration.
- `index.html` renders the essay index from `_data/essays.yml`.
- `_data/essays.yml` is the manifest that controls the published essay list.
- `_layouts/default.html`, `_includes/`, and `assets/css/style.scss` define the
  shared reading layout and styling.
- `<slug>/index.md` and `<slug>.html` files are published essay pages generated
  from source files at the repository root.

## Updating Published Essays

Do not edit generated essay pages here as the source of truth. Edit the source
essay in the relevant top-level folder, then run the publisher from the
repository root:

```sh
python3 scripts/publish-essays.py
```

Markdown entries in `_data/essays.yml` are copied to `<slug>/index.md`; HTML
entries are copied to `<slug>.html`. The GitHub Actions workflow
`.github/workflows/update-github-pages.yml` runs the same publisher on pushes to
`main` and commits any refreshed `docs/` output.

## Adding Essays

To publish a new essay, add its source file outside `docs/`, then add an entry
to `_data/essays.yml` with:

- `title`
- `collection`
- `description`
- `slug`
- `source`
- `type`

Run the publisher and review the generated page before committing.


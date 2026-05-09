# Warwick Allen's Essays

This repository contains theological essays and reflections by Warwick Allen,
along with the GitHub Pages site that publishes them at:

https://warwick-allen.github.io/essays/

The repository keeps the original essay sources at the top level and publishes
web-ready copies from `docs/`, using a manifest-driven publishing script.

## Repository Structure

- `Anthropology/`, `Dishonouring Christ/`, `Hebrews/`, `The Mission of God/`,
  `The Sunday Obligation and Eternal Consequences/`, and
  `Theological Profile/` contain the source essays.
- `docs/` contains the GitHub Pages site.
- `docs/_data/essays.yml` is the manifest that controls which essays appear on
  the site, how they are grouped, and where each published page lives.
- `scripts/publish-essays.py` copies manifest entries into `docs/` for
  publishing.
- `.github/workflows/update-github-pages.yml` runs the publishing script on
  pushes to `main` and commits any updated `docs/` output.

## Publishing Model

The source essays are the canonical files. Generated essay pages under `docs/`
are published copies and may be overwritten by `scripts/publish-essays.py`.

Markdown essays are copied to `docs/<slug>/index.md` with a small GitHub source
footer appended. HTML essays are copied to `docs/<slug>.html` as-is.

## Adding Or Updating Essays

To update an existing essay, edit its source file in the relevant top-level
folder. If the essay is already listed in `docs/_data/essays.yml`, the publish
script will refresh the corresponding page in `docs/`.

To add a new essay:

1. Add the source file to the appropriate top-level folder.
2. Add an entry to `docs/_data/essays.yml` with its `title`, `collection`,
   `description`, `slug`, `source`, and `type`.
3. Run the publisher:

   ```sh
   python3 scripts/publish-essays.py
   ```

4. Review the generated files under `docs/`.

The publisher requires Python 3 and PyYAML. The GitHub Actions workflow installs
PyYAML automatically; for local use, install it with:

```sh
python3 -m pip install PyYAML
```

## Site Files

The site is configured with Jekyll for GitHub Pages:

- `docs/_config.yml` contains the Pages and Markdown configuration.
- `docs/index.html` renders the essay index from `docs/_data/essays.yml`.
- `docs/_layouts/default.html`, `docs/_includes/`, and
  `docs/assets/css/style.scss` define the shared reading layout and styling.

GitHub Pages should be configured to deploy from the `main` branch using the
`/docs` folder.

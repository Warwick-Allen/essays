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

## Local preview (Jekyll)

The published site uses GitHub Pages’ Jekyll stack. To render it locally with
the same dependency versions as production, use Bundler with `Gemfile` /
`Gemfile.lock` in this directory.

**Prerequisites**

- Ruby 3.x (`ruby --version`)
- Bundler (`gem install bundler`)
- On Debian, Ubuntu, or WSL: install build tooling so native gems compile

  ```sh
  sudo apt install ruby-dev build-essential
  ```

**Serve with live reload**

From the repository root:

```sh
./scripts/serve-jekyll.sh
```

Or from `docs/`:

```sh
bundle install
bundle exec jekyll serve
```

Open **http://127.0.0.1:4000/essays/** (`baseurl` in `_config.yml` matches the
live site path).

**GitHub API token (optional)**

The `github-pages` gem includes `jekyll-github-metadata`, which can call the
GitHub API to populate `site.github.*` in Liquid. If no credentials are
available, you may see a message that no GitHub API authentication was found.
That is **harmless** for normal local preview (layout, styles, and essay
content).

To authenticate (quieter logs and correct metadata if templates use
`site.github`), set **`JEKYLL_GITHUB_TOKEN`** or **`GITHUB_TOKEN`** to a
personal access token with at least read access to this repository, then run
Jekyll as usual. Do not commit the token or add it to `_config.yml`.

If you use the GitHub CLI, **`gh auth token` requires a recent `gh` version**.
On older CLI releases the command is missing: the shell may substitute an error
message into the variable, which **breaks** the build (invalid HTTP headers).
Check with `gh auth token --help` or upgrade `gh` before using:

```sh
export JEKYLL_GITHUB_TOKEN="$(gh auth token)"
./scripts/serve-jekyll.sh
```

If that fails, create a token under GitHub → Settings → Developer settings, and
export it manually for the session.

**Static HTML only** (writes to `docs/_site/`):

```sh
./scripts/build-jekyll.sh
```

Gems install under `docs/vendor/bundle/` (see `.bundle/config`) so Bundler does
not require system-wide writes.

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


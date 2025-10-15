# GitHub Pages Configuration

This directory contains the files for the GitHub Pages website hosting Warwick Allen's Theological Profile.

## Files

- `index.md` - The main theological profile document (automatically synced from `Theological Profile/warwick_allen_theological_profile.md`)
- `_config.yml` - Jekyll configuration for GitHub Pages

## Automatic Updates

The GitHub Actions workflow `.github/workflows/update-github-pages.yml` automatically copies any changes from the source theological profile to this directory when commits are pushed to the main branch.

## Viewing the Site

Once GitHub Pages is enabled, the site will be available at:
https://warwick-allen.github.io/essays/

## Setup Instructions

To enable GitHub Pages for this repository:

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under "Build and deployment":
   - **Source**: Deploy from a branch
   - **Branch**: main
   - **Folder**: /docs
4. Click **Save**

GitHub will automatically build and deploy the site within a few minutes.


# GitHub Pages Setup Guide

This repository is configured to publish Warwick Allen's Theological Profile as a public-facing website using GitHub Pages.

## 📋 What Was Set Up

### 1. **docs Directory** (`/docs`)
   - Contains all files served by GitHub Pages
   - `index.md` - Copy of the theological profile (auto-synced)
   - `_config.yml` - Jekyll configuration
   - `assets/css/style.scss` - Custom styling for better presentation

### 2. **GitHub Actions Workflow** (`.github/workflows/update-github-pages.yml`)
   - Automatically copies changes from `Theological Profile/warwick_allen_theological_profile.md` to `docs/index.md`
   - Triggers on any commit to the main branch that affects the source file
   - Ensures the published version stays in sync with the source

### 3. **Jekyll Configuration** (`docs/_config.yml`)
   - Uses the Cayman theme for a clean, professional appearance
   - Configured with proper metadata and SEO settings
   - Enables automatic table of contents and other helpful features

### 4. **Custom Styling** (`docs/assets/css/style.scss`)
   - Enhanced typography and readability
   - Improved heading hierarchy
   - Mobile-responsive design
   - Print-friendly styling

## 🚀 Enabling GitHub Pages

To activate the website, follow these steps:

1. **Go to Repository Settings**
   - Navigate to https://github.com/Warwick-Allen/essays/settings/pages

2. **Configure GitHub Pages**
   - Under "Build and deployment":
     - **Source**: Deploy from a branch
     - **Branch**: `main`
     - **Folder**: `/docs`
   - Click **Save**

3. **Wait for Deployment**
   - GitHub will build and deploy the site automatically
   - This usually takes 1-3 minutes
   - You'll see a green checkmark when it's ready

4. **Access Your Site**
   - Your site will be available at: **https://warwick-allen.github.io/essays/**
   - The URL will be shown in the GitHub Pages settings once deployed

## 🔄 How Updates Work

### Automatic Updates
When you commit changes to `Theological Profile/warwick_allen_theological_profile.md`:
1. The GitHub Actions workflow detects the change
2. Automatically copies the updated file to `docs/index.md`
3. Commits and pushes the change
4. GitHub Pages rebuilds the site (takes 1-3 minutes)

### Manual Updates
If you need to manually trigger an update:
1. Go to the **Actions** tab in your repository
2. Select "Update GitHub Pages" workflow
3. Click "Run workflow" → "Run workflow"

## 📝 Making Changes

### To Update the Theological Profile
Simply edit: `Theological Profile/warwick_allen_theological_profile.md`
- Changes will automatically sync to the website
- No need to manually update the docs folder

### To Modify Styling
Edit: `docs/assets/css/style.scss`
- Changes take effect on next deployment

### To Change Theme or Settings
Edit: `docs/_config.yml`
- Available themes: cayman, minimal, slate, architect, etc.
- See [GitHub Pages themes](https://pages.github.com/themes/)

## 🎨 Theme Options

The current theme is **Cayman** (clean and professional). To try different themes, edit `docs/_config.yml` and change the `theme` line:

```yaml
theme: jekyll-theme-minimal     # Minimalist
theme: jekyll-theme-slate       # Dark theme
theme: jekyll-theme-architect   # Modern
theme: jekyll-theme-midnight    # Dark with sidebar
```

## 📱 Features

- ✅ Responsive design (mobile-friendly)
- ✅ Print-friendly styling
- ✅ Automatic table of contents
- ✅ Professional typography
- ✅ Clean, readable layout
- ✅ SEO-optimised
- ✅ Auto-updating from source

## 🔧 Troubleshooting

### Site Not Updating
1. Check the Actions tab for workflow errors
2. Ensure the workflow has write permissions
3. Verify the file path in the workflow matches your structure

### Styling Issues
1. Check that `assets/css/style.scss` is properly formatted
2. Clear browser cache (Ctrl+Shift+R / Cmd+Shift+R)
3. Wait a few minutes for GitHub Pages to rebuild

### Workflow Permissions
If the workflow fails with permission errors:
1. Go to Settings → Actions → General
2. Under "Workflow permissions", select "Read and write permissions"
3. Click Save

## 📖 Additional Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [GitHub Pages Themes](https://pages.github.com/themes/)
- [Markdown Guide](https://www.markdownguide.org/)

## 🎯 Next Steps

1. Enable GitHub Pages in repository settings (see above)
2. Wait for initial deployment
3. Visit your site and verify it looks correct
4. Share the URL with others
5. Make updates to your theological profile as needed - they'll automatically publish!

---

*Setup completed: October 2025*


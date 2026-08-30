# cdn-images

Public image host for HTML emails and anywhere else a plain image URL is needed.

## How to use

1. Drop images into this folder (subfolders are fine — e.g. `2026-tour/`, `logos/`).
2. Double-click **Sync.command**.
3. The public URLs print in the window and land on your clipboard.

Every image is reachable at:

```
https://soneaf.github.io/cdn-images/<path>/<filename>
```

## Finding a link later

- Open the gallery — https://soneaf.github.io/cdn-images/ — thumbnails with
  **Copy URL** and **Copy &lt;img&gt;** buttons for each image.
- Or from Terminal in this folder: `./link headshot` → prints and copies the URL.

## Notes

- The repo is **public**. Anything dropped here is readable by anyone with the link.
  Don't put contracts, personal documents, or anything unreleased in it.
- File names get made URL-safe automatically (spaces become dashes). If you rename or
  delete an image after sending an email, the link in that email breaks.

---
createdAt: 2025-04-14 14:20:28
modifiedAt: 2025-04-14 14:23:04
---
# Optimal CrawlLinks Configuration for Your KSBC Website

## Understanding CrawlLinks Plugin

The CrawlLinks plugin is essential for your setup as it manages how Quartz processes links within your content. This plugin parses all links in your Markdown files and processes them to point to the right locations, including internal links between notes and embedded links for images and other media.

## Recommended Configuration Options

Based on your repository structure and workflow, here are the optimal settings for the CrawlLinks plugin in your Quartz configuration:

```javascript
// In quartz.config.ts
plugins: {
  transformers: [
    Plugin.CrawlLinks({
      // Use absolute paths for most consistent experience across submodules
      markdownLinkResolution: "absolute",
      
      // Keep pretty links enabled for better readability
      prettyLinks: true,
      
      // Add icons to distinguish external links
      externalLinkIcon: true,
      
      // Optional: Configure external links to open in new tabs
      openLinksInNewTab: true,
      
      // Optional: Enable lazy loading for better performance with many images
      lazyLoad: true
    }),
    // Other transformers…
  ],
  // Other plugin categories…
}
```

## Explanation of Configuration Options

### 1. `markdownLinkResolution: "absolute"`

This is the most important setting for your setup. This determines how Quartz resolves Markdown paths, with three possible values: "absolute", "relative", or "shortest".

I recommend "absolute" for your multi-repository structure because:

- It ensures links work consistently across all submodules
- It provides clear paths relative to the content root, which helps with your tiered access model
- It's more predictable when working with nested repositories and complex directory structures
- It prevents confusion that could arise from relative paths in different submodules

While Obsidian typically defaults to "shortest path", the absolute path setting will work better for your specific setup with multiple submodules and nested content.

### 2. `prettyLinks: true`

When enabled, this simplifies the display of links by removing folder paths, making them more user-friendly (e.g., "folder/deeply/nested/note" becomes just "note"). This improves readability of your documents while maintaining the correct underlying link structure.

### 3. `externalLinkIcon: true`

This setting adds a small icon next to external links, which helps users distinguish between internal links (to other notes in your vault) and external links (to websites). This visual cue is particularly helpful for your educational content.

### 4. `openLinksInNewTab: true` (Optional)

This is recommended if you want external links to open in new browser tabs, keeping users on your site while allowing them to explore external resources. This can be especially useful for educational content where you want to reference external resources without losing readers.

### 5. `lazyLoad: true` (Optional)

If your content includes many images (especially in educational materials), enabling lazy loading will improve page load performance by only loading images as the user scrolls to them.

## Integration with Your Repository Structure

Your repository structure has several layers of nested content:

```
~/ksbc-website/ (Main Git repository - Quartz)
└── content/ (Git submodule - website-content - Obsidian vault)
    ├── public content
    ├── internal/
    │   ├── cadres/ (Git submodule - restricted access)
    │   └── members/ (Git submodule - member access)
    └── … other directories
```

With the absolute path resolution strategy:

1. Links from any file to another file will use paths relative to the content root
2. This means a file in `content/internal/cadres/` linking to a file in `content/public/` will use the path `../../public/file.md`
3. These absolute paths will be consistent regardless of where files are located in the repository hierarchy

## Complementary Configuration

For this setup to work perfectly, you should also ensure:

1. **Obsidian Settings Alignment**: You should use the same link format setting in Obsidian that you use in Quartz. Configure Obsidian to use absolute paths in Settings → Files & Links → New Link Format → "Absolute path in vault"
    
2. **Add Appropriate ignorePatterns** in quartz.config.ts:
    
    ```javascript
    ignorePatterns: [
      ".obsidian/",
      "_templates/",
      "_scripts/",
      "internal/assets/",
      "internal/personal/",
      "personal/",
      "drafts/",
      // Any other paths you want to exclude from the public website
    ],
    ```
    
3. **Use ExplicitPublish Filter** (optional): You can add the ExplicitPublish filter to your configuration, which will only publish pages that have "publish: true" in their frontmatter. This gives you additional control over what content is made public.
    

## Handling Nested Submodule Links

One potential challenge in your setup is links between different submodules. The CrawlLinks configuration above will handle these well, but you should be aware of a few considerations:

1. Links between submodules (e.g., from `members` to `cadres`) will work in Obsidian for users who have access to both repositories
2. For users without access to certain submodules, these links will appear broken in Obsidian
3. On the published website, links to unpublished content will lead to 404 pages

You can address the last issue by adding a custom 404 page that explains why certain content might not be accessible, as some users have done with similar setups.

Would you like more detailed information or examples for any particular aspect of this configuration?
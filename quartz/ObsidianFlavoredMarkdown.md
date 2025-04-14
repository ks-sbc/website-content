---
createdAt: 2025-04-14 14:22:10
modifiedAt: 2025-04-14 14:24:39
---
# Optimal ObsidianFlavoredMarkdown Configuration for Your KSBC Website

## Understanding the ObsidianFlavoredMarkdown Plugin

The ObsidianFlavoredMarkdown plugin is a crucial component for your repository structure as it ensures compatibility between Obsidian's unique Markdown syntax and Quartz's rendering system. This plugin transforms Obsidian's special syntax features into standard HTML that can be displayed correctly on your public-facing website.

## Core Functionality

The ObsidianFlavoredMarkdown plugin handles several Obsidian-specific Markdown extensions that are not part of standard Markdown:

1. **Wikilinks**: Transforms Obsidian's `[[Page Name]]` syntax into proper HTML links that work on the web
2. **Callouts/Admonitions**: Converts Obsidian's callout blocks (like `> [!NOTE]`) into styled HTML containers
3. **Embeds**: Processes file embeds like `![[image.png]]` or note embeds like `![[Note Title]]`
4. **Highlighting**: Handles Obsidian's `==highlighted text==` syntax
5. **Comments**: Manages Obsidian's comment syntax `%%comment%%`
6. **Checkbox Lists**: Ensures task lists with `- [ ]` and `- [x]` render correctly

## Recommended Configuration Options

For your multi-repository KSBC setup, I recommend the following configuration:

```javascript
// In quartz.config.ts
plugins: {
  transformers: [
    Plugin.ObsidianFlavoredMarkdown({
      // Enable wikilinks parsing and transformation
      enableInHtmlEmbed: true,
      
      // Configure wikilink display options
      wikilinks: {
        // How to resolve the text shown for the link
        nameAsLink: true,
        // Whether to keep the brackets in the output
        enableLegacy: false
      },
      
      // Keep all Obsidian callouts
      callouts: {
        enable: true
      },
      
      // Handle embedded content properly
      embedNodes: {
        // Enable both note and media embeds
        enable: true
      },
      
      // Support highlighting text with ==
      highlights: {
        enable: true
      },
      
      // Handle comment blocks appropriately
      comments: {
        enable: true,
        // Whether to strip comments entirely or preserve them as HTML comments
        stripComments: true
      },
      
      // Support checkbox lists
      checkboxes: {
        enabled: true,
        // Add interactive checkboxes (can be toggled by users)
        interactive: false
      }
    }),
    // Other transformers…
  ],
  // Other plugin categories…
}
```

## Explanation of Key Configuration Options

### 1. `enableInHtmlEmbed: true`

This option allows Obsidian-flavored Markdown to be processed even when embedded inside HTML. This is particularly important if you're using any HTML in your notes or if other plugins generate HTML that contains Markdown.

### 2. `wikilinks` Configuration

The `wikilinks` settings are crucial for your multi-repository setup:

- `nameAsLink: true` - Uses the page name as the link text, which maintains consistency between Obsidian and your published site
- `enableLegacy: false` - Uses the more modern link format rather than legacy Obsidian syntax

With these settings, a wikilink like `[[Important Concept]]` will appear as "Important Concept" in the published site rather than showing the full path.

### 3. `callouts` Configuration

Callouts are especially valuable for educational content, allowing you to create visually distinct note blocks, warnings, tips, and more. Enabling them ensures your educational materials maintain their visual hierarchy and emphasis when published.

### 4. `embedNodes` Configuration

This is critical for your setup because:

- It enables embedding content from one note into another
- It allows proper rendering of embedded images, which may be stored in your repository or submodules
- It's essential for creating comprehensive educational documents that reference other materials

### 5. `comments` Configuration with `stripComments: true`

Setting `stripComments` to true will completely remove any commented content from the published website. This is valuable for your tiered access model because:

- You can include comments in your Obsidian notes for team members
- Those comments won't appear in the published website
- You can use comments to leave notes about sensitive information or internal processes

### 6. `checkboxes` Configuration with `interactive: false`

For a static educational website, keeping checkboxes non-interactive is typically best. This preserves their appearance but prevents confusion from readers trying to interact with them. If your site has educational checklists or guides, they'll appear visually correct without creating false expectations about interactivity.

## Integration with Your Repository Structure

The ObsidianFlavoredMarkdown plugin complements your tiered repository structure in several ways:

1. **Consistent Experience**: Team members editing in Obsidian will see the same syntax highlighting and preview as the final published website
    
2. **Content References Across Repositories**: Wikilinks can reference content across your main repository and submodules while maintaining proper paths when published
    
3. **Hidden Comments**: Internal comments visible to your team in Obsidian won't appear in the published website
    
4. **Flexible Embeds**: Content from the public repository can embed images or reference notes from the members or cadres repositories (though these will only work for users with appropriate access)
    

## Complementary Configuration

For optimal results, combine this plugin configuration with:

1. **CrawlLinks Plugin**: As we discussed previously, set to use absolute paths for consistent link resolution
    
2. **Frontmatter Plugin**: To properly process Obsidian frontmatter with fields like `tags`, `aliases`, and custom fields
    
3. **RemoveDrafts or ExplicitPublish Filters**: To control which content gets published:
    
    ```javascript
    // Either use RemoveDrafts to exclude anything marked as a draft
    Plugin.RemoveDrafts(),
    
    // Or use ExplicitPublish to only include content explicitly marked for publishing
    Plugin.ExplicitPublish(),
    ```
    
4. **Asset Configuration**:
    
    ```javascript
    // Handle assets properly for embeds
    Plugin.Assets({
      // Optional: Configure asset handling
    }),
    ```
    

## Obsidian Settings Alignment

For consistency between Obsidian and your published website, ensure your team's Obsidian installations use compatible settings:

1. Enable "Strict line breaks" in Obsidian (to match Markdown's standard behavior)
2. Configure wikilinks to use consistent formats
3. Establish standard practices for callouts, embeds, and other Obsidian-specific features

## Potential Challenges and Solutions

1. **Broken Embeds**: If a published page embeds content that isn't published (e.g., from a restricted repository), those embeds will appear broken
    
    - Solution: Use comments to remind authors which embedded content will be visible publicly
2. **Inconsistent Callout Styling**: Obsidian's default callout styles might not match your website's theme
    
    - Solution: Add custom CSS to Quartz to style callouts consistently with your branding
3. **Complex Nested Embeds**: Deeply nested embeds (embeds within embeds) can create complexity
    
    - Solution: Establish guidelines for your team about appropriate embed depth

By properly configuring the ObsidianFlavoredMarkdown plugin, you'll ensure a seamless experience for both your content creators using Obsidian and your website visitors, all while maintaining your tiered access control system through your clever Git repository structure.
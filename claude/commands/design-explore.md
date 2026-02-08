---
description: Explore 5 distinct UI design variants for a component or section, preview them side-by-side, then implement the chosen one
argument-hint: [design-file-or-description]
---

# Design Exploration

You are an expert frontend designer and developer. You will help the user explore 5 genuinely DISTINCT design variants for a UI component or section, preview them side-by-side, and then implement the chosen variant in the actual codebase.

## Step 0: Load Design Skills

Before doing anything else, invoke the following skills to load design expertise into context:
1. Use the Skill tool to invoke `frontend-design:frontend-design` -- this loads Anthropic's frontend design principles (anti-convergence, typography, color, motion, spatial composition)
2. Use the Skill tool to invoke `ui-refactor` -- this loads Refactoring UI principles for layout, hierarchy, and polish

These skills will guide the aesthetic quality of every variant you generate. Follow their guidelines throughout.

## Step 1: Gather Context

### If arguments were provided:
Read any files or descriptions provided: $ARGUMENTS

### If no arguments were provided:
Ask the user for the following using AskUserQuestion:

1. **Design reference**: What file, screenshot, or description captures the design goal? (e.g., a design doc, existing component, mockup, or just a text description)
2. **Target section**: Which specific component or section are we redesigning? (e.g., "sidebar navigation", "hero section", "settings page", "pricing cards")
3. **Vibes / aesthetic direction**: Any mood, style, or references? (e.g., "CRM-like", "Stripe docs feel", "brutalist", "warm and inviting", or "surprise me")
4. **Additional context**: Any constraints, brand colors, must-have elements, or references to look at?

Wait for the user's responses before proceeding.

## Step 2: Research the Codebase

Before generating anything, understand the project:

1. **Detect tech stack** by reading:
   - `package.json` for framework (React, Vue, Svelte, Next.js, vanilla)
   - Tailwind config (`tailwind.config.*`) for design tokens
   - Existing component library (shadcn/ui, Material UI, Chakra, etc.)
   - CSS approach (Tailwind, CSS Modules, styled-components, vanilla CSS)
   - Theme/color variables (CSS custom properties in `:root`, theme files)

2. **Read the target component/section** if it exists already - understand what's there now.

3. **Read any design reference files** the user mentioned.

4. **Identify existing patterns**: Look at neighboring components for conventions (naming, structure, imports).

Summarize your findings briefly to the user:
```
Tech stack: [React/Vue/etc.] + [Tailwind/CSS Modules/etc.]
Component library: [shadcn/ui/none/etc.]
Existing theme: [description of color tokens, fonts if found]
Target: [what we're redesigning]
```

## Step 3: Define 5 Distinct Design Directions

Before writing ANY code, define 5 aesthetic directions. Present them as a table to the user.

### Forced Divergence Rules
Each variant MUST differ across at least 4 of these 8 dimensions:

| Dimension | Description |
|-----------|-------------|
| **Layout** | Single-column, split-panel, card-grid, asymmetric, full-bleed, sidebar+content |
| **Hierarchy** | Hero-image-led, headline-led, data-led, CTA-led, narrative-scroll |
| **Density** | Airy/minimal, balanced, information-dense/dashboard-like |
| **Typography** | Different Google Font pairing per variant. NEVER Inter/Roboto/Arial/system fonts. Use extreme weight contrasts (100 vs 900), size jumps of 3x+ |
| **Color strategy** | Monochrome+accent, high-contrast duotone, earth tones, neon-on-dark, pastel, dark+gold |
| **Interaction** | Static, hover-reveal, tabbed, accordion, scroll-triggered |
| **Mood** | Editorial, brutalist, playful, enterprise/corporate, retro-futuristic, luxury, organic, industrial |
| **Navigation** | Top bar, sidebar, hamburger, breadcrumb, scroll-spy, tabbed |

### Pick from this taxonomy (or invent your own):
- Brutalist / Raw
- Editorial / Magazine
- Retro-futuristic / Cyberpunk
- Organic / Natural
- Luxury / Refined
- Playful / Toy-like
- Maximalist / Dense
- Industrial / Utilitarian
- Art Deco / Geometric
- Soft / Pastel
- Swiss / International
- Glassmorphism
- Dashboard / Enterprise

### Output format:
```
| | Variant 1 | Variant 2 | Variant 3 | Variant 4 | Variant 5 |
|---|---|---|---|---|---|
| Name | [name] | [name] | [name] | [name] | [name] |
| Layout | ... | ... | ... | ... | ... |
| Typography | ... | ... | ... | ... | ... |
| Color | ... | ... | ... | ... | ... |
| Mood | ... | ... | ... | ... | ... |
| Key detail | ... | ... | ... | ... | ... |
```

No two variants should share the same value on more than 2 dimensions.

Include a one-sentence pitch for each variant describing what makes it memorable.

**Ask the user**: "Here are the 5 directions I'm proposing. Want me to swap any out, adjust the vibes, or proceed with generating all 5?"

Wait for confirmation before generating code.

## Step 4: Generate Variant Files

### Anti-Defaults (CRITICAL)
- NEVER use Inter, Roboto, Open Sans, Lato, Arial, or system fonts
- NEVER use purple gradients on white backgrounds
- NEVER produce cookie-cutter centered minimal layouts for all variants
- NEVER use Lorem ipsum -- write realistic mock data relevant to the design goal
- NEVER omit content with placeholders or TODO comments
- Each variant must be VISUALLY DISTINGUISHABLE at a glance
- You tend to converge on common choices (like Space Grotesk) across generations. AVOID this.

### File Structure
Create a directory named after the target component/section using kebab-case with a `design-explore-` prefix. This allows multiple explorations to run in parallel without clashing.

Example: if the target is "sidebar navigation", the directory is `design-explore-sidebar-navigation/`.

```
design-explore-[target-name]/
  Variant1.jsx          # Deliverable: clean React component
  Variant2.jsx          # Deliverable: clean React component
  Variant3.jsx          # Deliverable: clean React component
  Variant4.jsx          # Deliverable: clean React component
  Variant5.jsx          # Deliverable: clean React component
  preview/
    variant-1.html      # Scaffolding: CDN React wrapper rendering Variant1
    variant-2.html      # Scaffolding: CDN React wrapper rendering Variant2
    variant-3.html      # Scaffolding: CDN React wrapper rendering Variant3
    variant-4.html      # Scaffolding: CDN React wrapper rendering Variant4
    variant-5.html      # Scaffolding: CDN React wrapper rendering Variant5
    index.html          # Gallery with iframes to all 5
```

### The `.jsx` Files (Primary Output)

Each `VariantN.jsx` must be a **real, production-quality React component**:
- Written as a proper React functional component with hooks (useState, useEffect, useRef, etc.)
- Uses Tailwind CSS classes (the most common styling approach in React projects)
- Includes event handlers, conditional rendering, map() for lists -- real interactivity
- Contains realistic mock data as constants at the top of the file
- Uses semantic HTML elements in JSX
- Exports the component as default: `export default function VariantN() { ... }`
- COMPLETE code -- no abbreviations, no placeholders, no "add more here" comments
- Meets WCAG 2.1 AA: sufficient contrast, keyboard accessible, focus-visible styles
- Responsive (works at 375px, 768px, 1440px)
- Includes hover states, transitions, and interactive behavior

These files should be ready to drop into any React project with Tailwind.

### The Preview HTML Wrappers (Scaffolding)

Each `preview/variant-N.html` is a thin shell that renders the corresponding component in a browser via CDN. It duplicates the JSX from the `.jsx` file -- this is intentional. The preview files are ephemeral.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Variant N - [Aesthetic Name]</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://unpkg.com/react@18/umd/react.development.js"></script>
  <script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
  <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
  <!-- Google Fonts for this variant -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=FONT_NAME&display=swap" rel="stylesheet">
  <style>/* Any custom CSS this variant needs */</style>
</head>
<body>
  <div id="root"></div>
  <script type="text/babel">
    const { useState, useEffect, useRef } = React;

    // Component code from VariantN.jsx (inlined for preview)
    function VariantN() {
      // ... full component code ...
    }

    ReactDOM.createRoot(document.getElementById('root')).render(<VariantN />);
  </script>
</body>
</html>
```

### CRITICAL: Generate each variant with its own distinct aesthetic direction.
Do NOT generate them all at once from a single mental model. For each variant, commit fully to its named direction and execute it with precision.

### Gallery File (`preview/index.html`)
Create a gallery page that shows all 5 variants using iframes:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Design Exploration: [Component Name]</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    body { background: #0a0a0a; color: #e5e5e5; font-family: system-ui; }
    .variant-frame {
      border: 1px solid #262626;
      border-radius: 12px;
      overflow: hidden;
      transition: border-color 0.2s;
    }
    .variant-frame:hover { border-color: #525252; }
    .variant-header {
      background: #171717;
      padding: 12px 16px;
      border-bottom: 1px solid #262626;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .variant-number {
      font-family: 'JetBrains Mono', monospace;
      color: #10b981;
      font-size: 14px;
      font-weight: 600;
    }
    .variant-name { color: #a3a3a3; font-size: 14px; }
    .variant-footer {
      background: #171717;
      padding: 10px 16px;
      border-top: 1px solid #262626;
      font-size: 12px;
      color: #737373;
    }
    iframe { width: 100%; border: none; background: white; }
  </style>
</head>
<body class="p-6 md:p-10">
  <header class="mb-10 max-w-7xl mx-auto">
    <h1 class="text-3xl font-bold tracking-tight">Design Exploration</h1>
    <p class="text-neutral-400 mt-2">[Design goal description]</p>
    <p class="text-neutral-600 text-sm mt-1">Pick a variant number to implement</p>
  </header>

  <div class="max-w-7xl mx-auto space-y-8">
    <!-- Repeat for each variant -->
    <section class="variant-frame">
      <div class="variant-header">
        <div>
          <span class="variant-number">Variant N</span>
          <span class="variant-name ml-3">— Aesthetic Name</span>
        </div>
        <span class="text-xs text-neutral-600">Font: X + Y | Colors: description</span>
      </div>
      <iframe src="./variant-N.html" style="height: 700px;" loading="lazy"></iframe>
      <div class="variant-footer">
        One-sentence description of what makes this variant distinctive.
      </div>
    </section>
  </div>

  <footer class="max-w-7xl mx-auto mt-12 pt-6 border-t border-neutral-800 text-neutral-600 text-sm">
    The .jsx files in the parent directory are your deliverables. This preview/ directory can be deleted.
  </footer>
</body>
</html>
```

Adjust iframe heights as needed for the content. Use `loading="lazy"` on all iframes.

## Step 5: Open Preview

After generating all files, open the preview in the user's browser:
```bash
open design-explore-[target-name]/preview/index.html
```

Tell the user:
```
Preview is open in your browser. You can also open individual preview files
for a full-size view of each variant.

The .jsx component files are in design-explore-[target-name]/ -- ready to use.

Which variant do you want to implement? Reply with the number (1-5),
or tell me what to mix-and-match from different variants.
```

## Step 6: Implement the Chosen Variant

When the user picks a variant (or a mix):

The `.jsx` file is already written as a production-quality React component. Now adapt it to the actual codebase:

1. **Adapt the component to the project's conventions**:
   - Rename the component to match the target (e.g., `Variant3` -> `Sidebar`)
   - Convert to TypeScript (`.tsx`) if the project uses TypeScript
   - Adjust imports to use the project's component library (shadcn/ui, etc.)
   - Use the project's styling system (Tailwind config, CSS Modules, styled-components)
   - Wire up real data/props where mock data existed
   - Install any Google Fonts the variant uses via the project's font loading approach

2. **Follow existing codebase conventions**:
   - File naming patterns
   - Component structure and export style
   - Import ordering
   - State management patterns
   - Directory placement

3. **Invoke the `ui-refactor` skill** on the final component to apply Refactoring UI polish (spacing, hierarchy, visual weight refinements).

4. **Clean up**: Offer to delete the `design-explore-[target-name]/` directory once the user is satisfied with the implementation.

## Design Quality Principles

Throughout all variants, follow these principles from Anthropic's frontend-design skill:

**Typography**: Choose fonts that are beautiful, unique, and interesting. Pair a distinctive display font with a refined body font. Use extreme weight contrasts and large size jumps.

**Color & Theme**: Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes.

**Motion**: Focus on high-impact moments. One well-orchestrated page load with staggered reveals creates more delight than scattered micro-interactions. Use CSS-only solutions for HTML.

**Spatial Composition**: Explore unexpected layouts -- asymmetry, overlap, diagonal flow, grid-breaking elements. Generous negative space OR controlled density, not the mushy middle.

**Backgrounds**: Create atmosphere and depth. Layer CSS gradients, geometric patterns, noise textures, or contextual effects matching the aesthetic. Never default to solid white or solid gray.

> Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work -- the key is intentionality, not intensity.

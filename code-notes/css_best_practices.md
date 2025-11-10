# CSS Best Practices and Organization Techniques (2024)

## Modern CSS Architecture

### Custom Properties System
```css
/* Define properties at root level */
:root {
  /* Color system */
  --color-primary-100: hsl(220 100% 95%);
  --color-primary-500: hsl(220 100% 50%);
  --color-primary-900: hsl(220 100% 15%);
  
  /* Semantic colors */
  --color-text: var(--color-primary-900);
  --color-background: var(--color-primary-100);
  
  /* Spacing system */
  --space-unit: 0.25rem;
  --space-1: calc(var(--space-unit) * 1);
  --space-4: calc(var(--space-unit) * 4);
  
  /* Component-specific tokens */
  --card-padding: var(--space-4);
  --card-radius: 0.5rem;
}

/* Type validation for custom properties */
@property --card-radius {
  syntax: '<length>';
  initial-value: 0.5rem;
  inherits: true;
}
```

### Cascade Layers
Organize styles by importance and specificity:
```css
/* Define layer order */
@layer reset, base, components, utilities;

/* Reset layer */
@layer reset {
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
}

/* Base styles */
@layer base {
  body {
    font-family: system-ui;
    line-height: 1.5;
  }
}

/* Component styles */
@layer components {
  .card {
    padding: var(--card-padding);
    border-radius: var(--card-radius);
  }
}

/* Utility classes */
@layer utilities {
  .flex { display: flex; }
  .grid { display: grid; }
}
```

### Container Query Pattern
Organize component styles based on their container:
```css
/* Define reusable container sizes */
.container {
  container-type: inline-size;
  container-name: main;
}

/* Component variations based on container */
@container main (min-width: 30em) {
  .component {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(15em, 1fr));
  }
}

/* Style container queries */
.theme-container {
  container: theme / style;
  --theme-mode: 'light';
}

@container theme style(--theme-mode: 'dark') {
  .component {
    background: #333;
    color: white;
  }
}
```

## Modern Selectors and Combinations

### Parent-Child Relationships
```css
/* Select parent based on child state */
.card:has(> img) {
  padding: 0;
}

/* Complex relational selections */
.container:has(.sidebar:not([hidden])) main {
  margin-inline-start: var(--sidebar-width);
}

/* Quantity queries */
.grid:has(> :nth-child(6)) {
  --columns: 3;
  grid-template-columns: repeat(var(--columns), 1fr);
}
```

### Logical Properties
```css
.element {
  /* Use logical properties for better RTL support */
  margin-inline: auto;
  padding-block: 1rem;
  inset-inline-start: 0;
  
  /* Border logical properties */
  border-inline-start: 2px solid;
  border-end-start-radius: 0.5rem;
}
```

## Performance Patterns

### Content-Visibility
```css
/* Optimize rendering of off-screen content */
.section {
  content-visibility: auto;
  contain-intrinsic-size: 0 500px;
}

/* For important above-fold content */
.hero {
  content-visibility: visible;
}
```

### Will-Change Usage
```css
/* Optimize animations */
.modal {
  /* Inform browser about expected changes */
  will-change: transform, opacity;
  
  /* Remove when not animating */
  &.idle {
    will-change: auto;
  }
}
```

### Layer Creation Control
```css
/* Force layer creation for smooth animations */
.parallax {
  transform: translateZ(0);
  backface-visibility: hidden;
}
```

## Maintainable Media Queries

### Container Query First
```css
/* Prefer container queries for component-based design */
.card-container {
  container: card / inline-size;
}

@container card (min-width: 30em) {
  .card {
    display: grid;
    grid-template-columns: auto 1fr;
  }
}

/* Fallback to media queries for page-level concerns */
@media (max-width: 40em) {
  .layout {
    grid-template-columns: 1fr;
  }
}
```

### Custom Media Queries
```css
/* Define reusable breakpoints */
@custom-media --viewport-small (width < 40em);
@custom-media --viewport-medium (40em <= width < 60em);
@custom-media --viewport-large (60em <= width);

@media (--viewport-small) {
  .content { padding: 1rem; }
}
```

## State Management

### Data Attributes for States
```css
/* Use data attributes for state management */
[data-state='loading'] {
  opacity: 0.7;
  pointer-events: none;
}

[data-expanded='true'] {
  height: auto;
  opacity: 1;
}

/* Combine with :has() for parent states */
.card:has([data-state='error']) {
  border-color: var(--color-error);
}
```

## CSS Custom Hooks

### Reusable Style Patterns
```css
/* Define reusable style hooks */
.use-fade-in {
  --fade-duration: 300ms;
  --fade-timing: ease-out;
  
  animation: fade-in var(--fade-duration) var(--fade-timing);
}

.use-responsive-container {
  --min-content: 20rem;
  --max-content: 90rem;
  
  width: min(var(--max-content), 100% - 2rem);
  margin-inline: auto;
}
```

## Best Practices

1. Property Organization
   - Group related properties
   - Use logical property order
   - Keep animations/transitions together

2. Specificity Management
   - Use layers to control specificity
   - Avoid ID selectors
   - Minimize nesting depth

3. Performance Optimization
   - Use content-visibility wisely
   - Control layer creation
   - Minimize paint operations

4. Maintainability
   - Document complex selectors
   - Use meaningful custom property names
   - Keep component styles isolated

5. Browser Support
   - Check feature support
   - Provide fallbacks
   - Test across browsers

## Future-Proofing Strategies

1. Component Isolation
   - Use shadow DOM when appropriate
   - Implement scoped styles
   - Follow component-first architecture

2. Progressive Enhancement
   - Layer features based on support
   - Use @supports for feature detection
   - Provide basic experience first

3. Documentation
   - Comment complex calculations
   - Explain architectural decisions
   - Document breaking changes
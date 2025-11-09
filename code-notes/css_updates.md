# CSS Updates and Modern Features (2024)

## Container Queries and Units
Container queries represent a fundamental shift in responsive design, moving from viewport-based to component-based responsiveness.

### Size Container Queries
```css
.element-wrap {
  container: element / inline-size;
}

@container element (min-inline-size: 300px) {
  .element {
    display: flex;
    gap: 1rem;
  }
}
```

### Style Container Queries
Allow styles to change based on container's custom property:
```css
.theme-container {
  --variant: 1;
  
  &.alternate {
    --variant: 2;
  }
}

@container style(--variant: 1) {
  .component { /* styles */ }
}
```

### Container Units
New relative units based on container size:
- `cqi`: Container-relative size in the inline direction
- `cqb`: Container-relative size in the block direction
- `cqmin`: Smaller value between `cqi` and `cqb`
- `cqmax`: Larger value between `cqi` and `cqb`

```css
.responsive-element {
  font-size: clamp(1rem, 3cqi, 2rem);
  padding: 2cqi;
}
```

## Advanced Selectors

### :has() Selector
The `:has()` selector enables powerful parent and relational selections:

```css
/* Basic parent selection */
.card:has(img) {
  grid-auto-flow: row;
}

/* Quantity queries */
.grid:has(> :nth-child(5)) {
  grid-template-columns: repeat(3, 1fr);
}

/* State-based styling */
html:has(#dark-mode:checked) {
  color-scheme: dark;
}

/* Form validation */
form:has(:user-invalid) .error {
  display: block;
}
```

## Subgrid
Subgrid allows nested grids to use parent tracks:

```css
.main-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(30ch, 1fr));
  
  > article {
    display: grid;
    grid-row: span 4;
    grid-template-rows: subgrid;
  }
}
```

## Native Nesting
CSS now supports native nesting without preprocessors:

```css
.component {
  /* Base styles */
  color: var(--text-color);
  
  /* Nested media query */
  @media (prefers-color-scheme: dark) {
    --text-color: white;
  }
  
  /* Nested pseudo-classes */
  &:is(:hover, :focus-visible) {
    transform: scale(1.02);
  }
}
```

## Scroll-Driven Animations
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.element {
  animation: fadeIn;
  animation-timeline: scroll();
  animation-range: entry 50% cover 50%;
}
```

## New Color Spaces
### HWB, LCH, and LAB
```css
.element {
  /* HWB: Hue, Whiteness, Blackness */
  color: hwb(194 0% 0%);
  
  /* LCH: Lightness, Chroma, Hue */
  background: lch(50% 50 50);
  
  /* LAB */
  border-color: lab(50% 50 50);
}
```

## Best Practices
1. Progressive Enhancement
   - Provide fallbacks for newer features
   - Use @supports where needed
   - Layer styles from basic to enhanced

2. Performance
   - Use container queries judiciously
   - Test scroll animations for performance
   - Consider containment implications

3. Browser Support
   - Check caniuse.com for current support
   - Implement graceful degradation
   - Test across major browsers

## Future Features Watch
- Advanced container query capabilities
- New color space additions
- Enhanced animation controls
- More powerful selector combinations
# HeraldReborn Trait System (for Art Brainstorming)

Traits are **derived deterministically** from the two hashes. This gives you a rich, on-chain generative system without off-chain metadata.

## Core Inputs
- **Static Hash** (32 bytes, immutable): Primary seed for emblem / structure.
- **Dynamic Hash** (32 bytes, owner-dependent): Secondary seed for color, atmosphere, and variation.

Use different byte slices or bit ranges from each hash to drive traits.

## Proposed Trait Categories

### 1. Emblem / Primary Structure (Static Hash dominant)
- **Emblem Shape** (bytes 0-3): Shield type, creature silhouette, geometric form, abstract symbol.
- **Emblem Complexity** (byte 4): Number of layers, divisions, or sub-elements.
- **Charge Type** (byte 5): Animal, object, celestial, plant, weapon, abstract glyph.
- **Symmetry** (byte 6): Full symmetry, partial, chaotic, radial.

### 2. Color Palette (Dynamic Hash dominant)
- **Primary Color** (bytes 0-1): Main hue family.
- **Secondary/Accent Color** (bytes 2-3).
- **Background Type** (byte 4): Solid, gradient, pattern field, textured, void.
- **Palette Temperature** (byte 5): Warm, cool, desaturated, high-contrast, monochromatic.
- **Metallic/Texture Flag** (byte 6): Gold, silver, enamel, parchment, neon, stone.

### 3. Pattern & Atmosphere (Combined hashes)
- **Field Pattern** (Static + Dynamic bytes): Dots, lines, crosshatching, stars, waves, heraldry diaper.
- **Border Style** (byte 8-9): Ornate, minimal, spiked, chained, glowing.
- **Particle / Accent Elements** (byte 10): Sparks, rays, floating symbols, cracks, vines.
- **Lighting / Mood** (Dynamic): Dramatic shadows, ethereal glow, harsh contrast, soft vignette.

### 4. Rarity / Evolution Traits (Advanced)
- **Transfer Count Influence**: More transfers could unlock subtle permanent visual mutations (stored in contract).
- **Owner History Fingerprint**: Last N owners can influence micro-details.
- **Time-based traits**: Block timestamp at mint or last transfer for seasonal palettes.

## Implementation Notes
- In `tokenURI()`, read specific bytes from `staticHashes[tokenId]` and `getDynamicHash(tokenId)`.
- Map byte values to trait enums or direct SVG parameters (e.g., `fill="#` + hex slice).
- Keep trait count reasonable (8-12 visual traits max) for clean art direction.
- All traits are fully on-chain and verifiable.

## Art Direction Tips
- Start with a strong emblem library (20-30 base shapes).
- Define 6-8 color palettes that feel heraldic yet fresh.
- Use the dynamic hash heavily for "mood" so transfers feel transformative.
- Pixel art or low-res vector style works best for gas-efficient SVG.

---
Ready for you to define the actual visual language. Once you pick a theme (e.g., cyber-heraldry, nature spirits, abstract sigils), we can map exact byte → trait logic and build the full SVG renderer.
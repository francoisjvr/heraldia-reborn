# Heraldia Technical Mechanics Analysis

**Source**: https://www.heraldia.art/
**Contracts**:
- Heraldia: `0x11a7e42036f8d039b0ce54b5488e3df0dff6cf36`
- Storage: `0x0d562a65d3a209738eba9601a88bb0a62bc66391`

## Core Architecture
- 100% on-chain generative NFT (ERC-721).
- No IPFS, no external dependencies, pure Solidity.
- SVG art rendered entirely inside the smart contract.

## Dual-Hash System (The Key Innovation)
Every token has two persistent hashes:

1. **Static Hash** (Immutable Emblem)
   - Generated randomly at mint time.
   - Defines the core emblem geometry, base pattern, and "soul" of the token.
   - Stored permanently. Never changes on transfer.
   - Passed from owner to owner untouched.

2. **Dynamic Hash** (Wallet-Driven Composition)
   - Computed from: `keccak256(owner_address + static_hash)` (inferred pattern).
   - Controls: colors, background, secondary patterns, overall visual treatment.
   - **Recomputed on every transfer** based on the *new* owner's address.
   - Result: Same emblem, completely different art.

## Minting Flow
- Emblem (static) is randomly generated and locked at mint.
- Cannot be chosen or predicted in advance.
- Initial dynamic state based on minter's wallet.

## Transfer Flow
- Standard ERC-721 transfer.
- No additional calls required.
- Smart contract automatically uses new owner address to derive fresh dynamic hash.
- Visual updates instantly on any ownership change.
- Creates "history" — each owner leaves a unique visual fingerprint.

## Rendering
- `tokenURI()` returns fully self-contained SVG (data: URI).
- All logic (hash derivation, pattern selection, color palettes, SVG construction) lives in Solidity.
- Pixel-art heraldic coats of arms.

## Supply & Philosophy
- 10,000 tokens.
- "Your wallet is the artist. Every transfer is a new brushstroke."
- Infinite evolution as long as tokens move between wallets.

## Additional On-Chain Features (Site-Implemented)
- Time Machine: View historical states of a token.
- Transfer Simulator: Preview how art changes for a target wallet.
- Stats: Transfer counts, "most wanted" tokens, recent activity.
- Fully transparent (verified contracts).

## Technical Strengths for Rebuild
- Elegant separation of immutable vs mutable visual layers.
- Ownership as creative input (strong game theory / social mechanics).
- Gas-efficient on-chain rendering possible with careful Solidity.
- Proven model for "living" generative collections.

## Next Steps for New Project
- Reimplement core dual-hash + SVG engine with new theme.
- Decide on new visual language, hash derivation tweaks, or extensions (e.g., multi-layer dynamics, evolution over time).
- Potential improvements: better gas optimization, richer SVG primitives, new interaction primitives.

---
*Research captured 2026-05-27. Ready to evolve into completely new collection.*
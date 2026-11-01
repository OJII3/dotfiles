# Geometry — coordinates, spacing, and collision rules

The canvas is a fixed-size absolutely-positioned coordinate system (default 1000px wide; height as needed). Nodes are `position:absolute` divs; edges live in one SVG overlay with the same viewBox as the canvas size. Because everything is hand-placed, the collision rules below are what keep the result clean.

## The node box

```
left = centerX - 66          (node div is 132 wide, text centered)
tile: 60x60, top of node div (tile spans centerX±30, topY..topY+60)
name: ~13px display font at topY+68
role: ~10px mono at topY+86
node box bottom ≈ topY + 100
```

So a node occupies roughly **132w × 100h**. All anchor math uses these numbers.

## Spacing constants

- Horizontal: ≥140px between node centers on the same row (labels are 132 wide — closer and they touch)
- Vertical: 140px between tile tops of consecutive rows (leaves ~40px clear between one row's box bottom and the next row's tile)
- Groups, left/right: edges 24px outside the outermost node *boxes*, i.e. `leftmost centerX − 90` and `rightmost centerX + 90`. Measure from the 132px box, not the 60px tile — a name wider than its tile otherwise crowds one side, and every group gets the same, symmetric padding
- Groups, top/bottom: top edge = first tile top − 60 (the group label lives in that band); **bottom edge ≥ last tile top + 150** so node text stays inside the box
- Group label: inside the top-left corner (`top:12px; left:12px`, no background), so the border stays unbroken. Keep edges out of that corner.
- Nested group: inset ≥24px from the parent on the sides and bottom, and start ≥48px below the parent's top edge (under the parent's label)

## Edge anchoring — the rule that prevents text collisions

**A node is its tile plus the text below it.** Treat `(centerX±66, topY..topY+100)` as the connection boundary.

- **Horizontal edges** (same row): connect tile side to tile side at tile mid-height, `y = topY+30`, from `x = centerX+30+4` to `x = targetCenterX-30-4`. This is safe because there's no text beside tiles.
- **Vertical edges** (node above node): connect **box bottom to tile top** — from `y = topY_upper + 100` down to `y = topY_lower - 4` (or upward, reversed). Never draw from tile bottom (`topY+60`) through the label text.
- **Elbow edges** (different row AND column): run the vertical segment in an x-corridor free of node boxes; run the horizontal segment in the clear band between rows (`topY_lower - 40 .. topY_lower - 10`). Crossing another *edge* is normal diagram practice; crossing a *node box* is not.
- Leave a 4–6px gap between line end and the boundary; arrowheads (`marker-end`) supply the touch.

Two layers of defense are built into the template — keep them:
1. Edge labels use `paint-order: stroke` with a paper-colored stroke (halo), so lines under them stay readable.
2. Node name/role text is wrapped in `<span>`s with paper background, so an unavoidable crossing line disappears behind the text instead of striking through it.

## Edge classes and labels

```html
<path class="e" d="M148 150 H306" marker-end="url(#ar)"/>        accent solid — primary flow
<path class="n" d="M487 226 V344" marker-end="url(#ar)"/>        neutral solid — internal
<path class="n dash" d="M318 380 H208" marker-end="url(#ar)"/>   dashed — dev/deploy
<text class="el a" x="227" y="142" text-anchor="middle">HTTPS</text>
```

The arrowhead marker is `#ar`. It fills with `context-stroke`, so it takes the color of whichever line uses it, in both themes — don't add per-color markers. AWS diagrams use `#open`, the same way.

- Horizontal edge label: centered above the line, `y = lineY - 8`
- Vertical edge label: right of the line, `x = lineX + 10`, vertically mid-segment
- Use `.el.a` (accent) for labels on accent edges, `.el` for the rest
- Keep labels to 1–2 short words; the role text under nodes carries the detail

## Worked example (the template's sample)

Canvas 1000×540. Row 1 tiles at top=120: User(cx 112), App(cx 342), API(cx 487). Row 2 tiles at top=350: Tool One(cx 172), Tool Two(cx 354). Vendor group around App and API `left:252 top:60 w:325 h:210` (342−90 → 487+90; top 120−60; bottom 270 = 120+150); tooling group `left:82 top:290 w:362 h:210` (172−90 → 354+90; top 350−60; bottom 500 = 350+150).

```
user→app        M148 150 H306      (horizontal, tile-mid: 112+30+6 → 342-30-6)   label "HTTPS" at (227, 142)
app→api         M376 150 H451      (horizontal, tile-mid)
tool2→tool1     M318 380 H208      (dashed, tile-mid of row 2: 354-30-6 → 172+30+6) label "pre-commit" at (263, 372)
```

A vertical edge from API down to a node at cx 487 in row 2 would be `M487 226 V344` (box bottom 120+100+6 → tile top 350-6).

Sanity-check your plan by listing every vertical/elbow segment and asking: which node boxes does this x-corridor pass through between y1 and y2? The answer must be none.

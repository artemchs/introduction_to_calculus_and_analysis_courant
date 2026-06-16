# Figure style — the Courant look

Every figure in this repository follows one visual language, modelled on the
plates in Courant & John's *Introduction to Calculus and Analysis*. The goal is
a restrained, engraving-like, **monochrome** figure that would not look out of
place in the printed book — and that survives black-and-white printing and
photocopying without losing information.

The style is encoded in code (`CourantUtils.use_courant_theme` and `plotn`), so
in practice you get it for free. This document records the *intent*, so new
figures — and any future helpers — stay consistent.

## Principles

1. **Monochrome, not colour.** Ink is black on a white ground. Curves are never
   told apart by hue. Anyone reading a grayscale print must get the full story.

2. **Shade + line style carry identity.** When several curves share a frame they
   are distinguished by a *pair* of cues that reinforce each other:

   | order | shade (gray) | line style    |
   |------:|:-------------|:--------------|
   |   1   | black `0.00` | solid         |
   |   2   | `0.50`       | dashed        |
   |   3   | `0.28`       | dotted        |
   |   4   | `0.66`       | dash-dot      |
   |   5   | `0.40`       | dash-dot-dot  |

   The pairing means the curves remain separable even if shade *or* style is
   lost (faint photocopy, low-res screen). Primary curves get the darkest, most
   solid treatment; auxiliary or comparison curves recede into lighter, broken
   strokes.

3. **Axes through the origin.** Coordinate axes cross at `(0, 0)`
   (`framestyle = :origin`), the way they are drawn by hand in the text — not a
   box around the data. The plotted range is widened slightly so curves breathe
   inside the frame.

4. **No grid.** Background grids are visual noise the textbook never uses. Read
   values from the axes and tick marks instead.

5. **Serif lettering.** Labels, ticks and titles are set in **Computer Modern**,
   the Knuth/TeX serif, to match mathematical typesetting. Keep type small and
   quiet.

6. **Quiet legends.** A thin black-ruled legend only when curves need naming;
   otherwise label inline or in the caption. No coloured swatches, no shadow.

## Captions

Treat each figure like a book plate: a short caption beneath it doing the
explaining (e.g. *"Fig. 1. The chord approaching the tangent."*) rather than a
busy title crammed into the axes.

## Using it

```julia
using CourantUtils

use_courant_theme()                       # style every later plot this session

plotn([sin, cos], 0, 2π;                  # several functions, one frame
      labels = ["sin x", "cos x"],
      title  = "Two elementary waves")
```

`plotn` applies the shade/line-style cycle automatically; `use_courant_theme`
extends the same defaults to plots you build by hand with `plot`/`plot!`.

## Extending the style

When you add new figure helpers, keep faith with the principles above:
monochrome, shade-plus-style identity, origin axes, no grid, serif type. If a
helper needs more than five distinct curves, extend the shade/style cycles in
`CourantUtils.jl` rather than reaching for colour.

module CourantUtils

using Plots
using Colors

export plotn, plotn!, use_courant_theme, courant_palette

# ---------------------------------------------------------------------------
# Courant textbook style
#
# Figures in Courant & John are monochrome: curves are told apart by a paired
# *grayscale shade* and *line style* rather than by colour, the axes run through
# the origin, the lettering is a serif (Computer Modern) face, and there is no
# background grid. The helpers below encode that language so every notebook in
# this repository produces consistent, print-friendly figures.
#
# See THEME.md at the repository root for the full design notes.
# ---------------------------------------------------------------------------

# Grayscale shades (0.0 = black), ordered so consecutive curves stay distinct.
const _SHADE_LEVELS = (0.0, 0.50, 0.28, 0.66, 0.40)

# Line styles cycled in lock-step with the shades.
const _LINE_STYLES = (:solid, :dash, :dot, :dashdot, :dashdotdot)

"""
    courant_palette() -> Vector{RGB}

The grayscale palette used throughout the repository, darkest first.
"""
courant_palette() = [RGB(g, g, g) for g in _SHADE_LEVELS]

_shade(i::Integer) = (g = _SHADE_LEVELS[mod1(i, length(_SHADE_LEVELS))]; RGB(g, g, g))
_style(i::Integer) = _LINE_STYLES[mod1(i, length(_LINE_STYLES))]

"""
    use_courant_theme()

Apply the Courant textbook style to every subsequent plot in the current
session by setting Plots.jl defaults: a white canvas with black ink, serif
(Computer Modern) lettering, axes drawn through the origin, no grid, and the
grayscale [`courant_palette`](@ref).

Call it once near the top of a notebook. Individual [`plotn`](@ref) calls are
already styled on their own, so this is mainly for hand-rolled `plot` calls.
"""
function use_courant_theme()
    default(;
        background_color = :white,
        background_color_inside = :white,
        foreground_color = :black,
        fontfamily = "Computer Modern",
        framestyle = :origin,
        grid = false,
        minorgrid = false,
        widen = true,
        linewidth = 1.4,
        markerstrokewidth = 0,
        palette = courant_palette(),
        legend_foreground_color = :black,
        legendfontsize = 9,
        tick_direction = :out,
    )
    return nothing
end

# Per-figure style applied by `plotn`, independent of the global theme.
_courant_base() = (
    background_color = :white,
    background_color_inside = :white,
    foreground_color = :black,
    fontfamily = "Computer Modern",
    framestyle = :origin,
    grid = false,
    widen = true,
)

"""
    plotn(fs, a, b; labels=nothing, npoints=400, kwargs...)

Plot the functions in `fs` over the interval `[a, b]` on a single set of axes in
the Courant textbook style. Each curve is distinguished by a paired grayscale
shade and line style, so the figure reads clearly in black and white.

# Arguments
- `fs`: a collection of single-argument functions, e.g. `[sin, cos]`.
- `a`, `b`: endpoints of the interval to sample.
- `labels`: optional vector of legend labels, one per function. When omitted no
  legend is drawn.
- `npoints`: number of sample points (default `400`).
- `kwargs...`: any extra Plots.jl attributes (`title`, `xlabel`, `ylims`, …),
  which override the style defaults.

# Examples
```julia
plotn([sin, cos], 0, 2π; labels = ["sin x", "cos x"], title = "Two waves")
plotn([x -> x^2, x -> x^3], -1.5, 1.5)
```
"""
function plotn(fs, a, b; labels = nothing, npoints = 400, kwargs...)
    attrs = merge(
        (; _courant_base()..., legend = isnothing(labels) ? false : :best),
        (; kwargs...),
    )
    plt = plot(; attrs...)
    return plotn!(plt, fs, a, b; labels = labels, npoints = npoints)
end

"""
    plotn!(plt, fs, a, b; labels=nothing, npoints=400)

Add the functions in `fs` to an existing plot `plt`, continuing the Courant
shade/line-style cycle. See [`plotn`](@ref).
"""
function plotn!(plt, fs, a, b; labels = nothing, npoints = 400)
    xs = range(a, b; length = npoints)
    for (i, f) in enumerate(fs)
        plot!(plt, xs, f.(xs);
            linecolor = _shade(i),
            linestyle = _style(i),
            linewidth = 1.4,
            label = isnothing(labels) ? "" : labels[i],
        )
    end
    return plt
end

end # module

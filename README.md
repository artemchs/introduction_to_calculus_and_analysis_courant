# Introduction to Calculus and Analysis (Courant)

This repository contains computational experiments for selected exercises from
*Introduction to Calculus and Analysis* by Richard Courant and Fritz John.

The experiments are written in [Julia](https://julialang.org/) using
[Pluto.jl](https://plutojl.org/) reactive notebooks.

## Structure

- `I/` — experiments for Volume I
- `II/` — experiments for Volume II
- `CourantUtils/` — a small local package with shared helpers (see below)
- [`THEME.md`](THEME.md) — the repository-wide figure style

## Running the notebooks

```julia
using Pluto
Pluto.run()
```

Then open the desired notebook from the Pluto interface.

## Shared helpers (`CourantUtils`)

`CourantUtils` is a local Julia package with utilities reused across notebooks —
most notably `plotn`, which draws several functions on one set of axes in the
monochrome Courant textbook style (see [`THEME.md`](THEME.md)).

To use it from a Pluto notebook in `I/` or `II/`, put this in the first cell —
it takes over package management for that notebook and develops the local
package straight from the repository:

```julia
begin
    import Pkg
    Pkg.activate(; temp = true)
    Pkg.develop(path = joinpath(@__DIR__, "..", "CourantUtils"))
    Pkg.add("Plots")
    using CourantUtils, Plots
end
```

Then:

```julia
plotn([sin, cos], 0, 2π; labels = ["sin x", "cos x"], title = "Two waves")
```

Call `use_courant_theme()` once to extend the same style to any `plot`/`plot!`
calls you write by hand.

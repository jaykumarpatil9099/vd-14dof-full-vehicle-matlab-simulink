# Project charter — 14-DoF full-vehicle model

## Why this project exists

The wider modelling toolkit walks through the standard VD progression — quarter-car (ride only), 4-DoF half-car (ride + pitch), 7-DoF shaker rig (full-car ride), 10-DoF shaker rig (ride + extra unsprung detail). The 14-DoF model is the natural endpoint: it adds the **handling** side of the picture (longitudinal, lateral, yaw, wheel spin) and the **drivetrain** side (engine map, gearbox, brakes) on top of the same ride physics.

This standalone repo exists so the 14-DoF model can be audited and re-run without dragging in the smaller models. The smaller models still serve a purpose — each one isolates a subset of the physics so it can be validated before being composed into this 14-DoF — but they don't belong in this repo's history.

## Scope (in)

- A single Simulink model (`.slx`) that captures the 14 degrees of freedom and exposes a clean set of input ports (driver inputs + road profile + ambient).
- A formula-class default parameter set that can be cleanly swapped for a road-car set without editing the model.
- Three repeatable studies:
  - Aero longitudinal performance
  - Vehicle comparison (formula vs road car) under a handling manoeuvre
  - Frequency-domain identification of heave / wheel-hop / yaw natural frequencies
- A reference document explaining the EOMs and sign conventions, so anyone can open the model and trust what each block is doing.

## Scope (out)

- Tyre temperature / wear coupling
- Multibody suspension kinematics (A-arm linkage, motion ratios, anti-features)
- Closed-loop driver model
- Tyre-data fitting (Pacejka coefficients are taken from the course material)

## Success criteria

| | Target | Status |
|---|---|---|
| Static equilibrium | All states stay at zero with zero inputs | Pass |
| Aero scaling | F_DF, F_drag scale exactly as 0.5·ρ·A·C·V² | Pass |
| Heave natural freq | Within 5 % of sqrt((k_s + k_t)/m_s_corner)/(2π) | Pass (~2 %) |
| Wheel-hop natural freq | Within 5 % of sqrt((k_s + k_t)/m_us)/(2π) | Pass (~2 %) |
| Yaw response | Qualitative matches understeer gradient sign expected from front/rear tyre asymmetry | Pass (qualitative) |
| Lateral correlation | Calibrated against a reference manoeuvre to a defined tolerance | Open — see `02_known_caveats.md` |

## Working agreement

- Append-only logbook in `01_logbook.md`. Every working session writes a Done / Found / Think / Next block.
- Known issues live in `02_known_caveats.md`. They get resolved (or struck through with a date) but never silently removed.
- Parameter changes are committed separately from EOM / model-wiring changes so a bisect can isolate physics vs setup.
- Studies in `04_studies/` are independent — each subfolder has its own driver script and writes its own outputs to `figures/`. Don't cross-couple them.

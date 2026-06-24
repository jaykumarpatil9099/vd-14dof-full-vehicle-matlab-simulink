# 14-DoF full-vehicle model — one-page overview

## What it is

A 14-degree-of-freedom Simulink model of a formula-class vehicle that couples the ride physics (heave, pitch, roll, 4 unsprung vertical) with the handling physics (x, y, yaw, 4 wheel rotational) under a real engine map, 8-speed gearbox, brakes, ARBs, and per-axle Pacejka Magic-Formula tyres.

## Why this scope

Smaller models (quarter-car, 4-DoF, 7-DoF shaker rig, bicycle) each capture *one* slice of the physics. The 14-DoF is the smallest model where you can ask combined questions: how does aero downforce change the longitudinal acceleration curve and the lateral grip available at the rear simultaneously? How does the front/rear ARB ratio interact with the front Pacejka coefficient set when the car is mid-corner under throttle? Those questions don't exist in any of the smaller models.

## What's verified

| Check | Method | Status |
|---|---|---|
| Static equilibrium | All states stay at zero with zero inputs (preloads cancel gravity) | Pass |
| Aero scaling | F_DF and F_drag scale as 0.5·ρ·A·C·V² | Pass |
| Heave natural freq | FFT of `z_s_dd` under constant-velocity chirp | Pass (~2 % vs hand calc) |
| Wheel-hop natural freq (F / R) | FFT of `z_us_dd` per axle | Pass (~2 %) |
| Pacejka peak μ per axle | Slip-angle sweep, front vs rear separately | Pass (qualitative — peaks at the right slip angles for each coefficient set) |

## What's still open

| Item | Where | Status |
|---|---|---|
| Lateral load-transfer brackets sign | Unsprung-mass EOMs | Under audit (C-001 in caveats) |
| Yaw response amplitude calibration | Body planar EOM | Open — qualitative correct, not calibrated |
| Initial-condition transient in FFT | Frequency study | Workaround in place (discard first 2 s) |

## What this model is useful for

- A teaching artefact for ride / handling coupling — every block is named so a third party can audit each EOM
- A platform for setup studies that can't be done on a 7-DoF shaker rig (e.g. aero balance vs roll-stiffness balance under combined throttle + steering)
- The intended consumer of the Pacejka coefficients used by the [`gt3-lap-time-simulator`](https://github.com/jaykumarpatil9099/gt3-lap-time-simulator) — when v06 of the lap simulator graduates from the QSS μ(F_z) surrogate to a slip-curve model, this is where those coefficients come from

## What this model is not

- Not a transient suspension model — corner spring + damper + ARB are lumped, no A-arm kinematics
- Not a tyre-data project — Pacejka coefficients are taken from course material, not fitted from a test campaign
- Not closed-loop — manoeuvre inputs are scripted, no driver model

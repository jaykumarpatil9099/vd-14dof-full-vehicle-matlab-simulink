# Known caveats — 14-DoF full-vehicle model

The list below tracks what the model does *not* currently get exactly right. Items are added when discovered and struck through (with a date) when fixed. Nothing is silently removed.

## Open

### C-001 — lateral-load-transfer brackets sign convention
**Where.** Unsprung-mass vertical EOMs (FL/FR/RL/RR), the `[Γ_ARB + m_s·(b or a)/L·a_y·h_RC + 2·m_us·a_y·h_USM] / track` term.
**Observation.** Under a steady-state lateral acceleration ramp, the inside-rear corner unloads as expected, but the front/rear load-transfer split deviates from the analytical geometric + elastic breakdown by more than what damping alone can explain.
**Hypothesis.** One of the three contributions inside the bracket (the ARB term, the roll-centre geometric term, or the unsprung-jacking term) has the wrong sign on the FR or RR branch — the leftmost two corners look correct.
**Plan.** Step through the assignment EOMs (final assignment PDF page 6) side-by-side with the Simulink ARB and load-transfer blocks. Cross-check against the 7-DoF shaker rig — that model is already known to be correct on this term.

### C-002 — yaw response amplitude not calibrated
**Where.** Yaw EOM in the body frame, downstream of the per-tyre lateral Pacejka force.
**Observation.** Yaw rate under a step-steer manoeuvre converges to a sensible steady-state value and the understeer-gradient sign is correct (formula vs road parameter sets clearly differ), but the *amplitude* hasn't been correlated against an external reference.
**Plan.** Compare against the bicycle-model single-track approximation at small slip angles — at low lateral acceleration the two models should converge.

### C-003 — initial-condition transient masks the natural-frequency FFT
**Where.** Frequency study (`04_studies/frequency_analysis/`).
**Observation.** Without a deliberate warm-up period the FFT of the heave / wheel-hop response is contaminated by the step response at t = 0.
**Workaround.** Discard the first 2 s of every run, or start the simulation from a known equilibrium state. The wider 7-DoF shaker rig uses the latter — port the same convention here.

## Resolved

*(none yet — items move here with a date once closed)*

# Aero study — longitudinal performance

**Question.** How much does aero downforce vs drag re-shape the longitudinal acceleration curve of the formula-class parameter set?

**Manoeuvre.** Straight-line full-throttle acceleration from rest. No road irregularities, no steering input, gear shifts on the engine-map up-shift / down-shift thresholds.

**Configurations.**
| Config | A [m²] | C_z | C_d |
|---|---|---|---|
| Baseline (default) | 1.25 | 1.00 | 0.40 |
| Low downforce | 1.25 | 0.30 | 0.30 |

**Channels.**
- Longitudinal acceleration vs vehicle speed
- Slip ratios per axle (to confirm RWD traction limit at low speed)
- Gear engaged (sanity-check the up-shift logic)
- Aero downforce and drag vs speed (overlay)

**Expected reading.** Acceleration vs speed is downforce-limited at low speed (more grip → more longitudinal force available before slip-ratio saturation) and drag-limited at high speed (top-speed gap closes once F_drag ≈ F_engine_max). The crossover speed is the main number to extract.

## To run

```matlab
>> startup_project
>> run('02_data/parameters/Complete_vehicle_simulation_dof14_model_parameters.m')
% set driver-input subsystem to full-throttle straight-line manoeuvre
>> sim('Complete_vehicle_simulation_dof14_model')
% post-process: see post_aero.m (planned)
```

Save figures into `../../figures/` with names `fig_aero_*`.

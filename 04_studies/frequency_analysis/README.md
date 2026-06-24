# Frequency-domain analysis

**Question.** Are the heave / pitch / roll / wheel-hop natural frequencies of the 14-DoF model consistent with the closed-form approximations? And does the yaw-rate response show a clean frequency-domain peak?

**Manoeuvre.**
- For ride modes: vehicle at rest (V = 0). Constant-velocity sine sweep injected into all four road-input ports (0.1 → 40 Hz over 100 s, velocity amplitude 0.05 m/s, integrated to displacement). Same input on all four corners → heave + wheel-hop only.
- For yaw mode: vehicle at 100 km/h. Steering-angle sine sweep (0.1 → 10 Hz over 50 s, 1 deg amplitude).

**Analysis.** FFT of sprung-mass `z_s_dd`, unsprung-mass `z_us_dd` (averaged per axle), and yaw rate `psi_dot`. Pick peaks inside the expected bands.

**Expected reading.**
| Mode | Hand calc | Notes |
|---|---|---|
| Heave (corner approx) | 2.77 / 3.17 Hz | front / rear, k_eff = k_s·k_t / (k_s + k_t) |
| Wheel-hop front | 28.10 Hz | sqrt((k_sf + k_t)/m_usf) / (2π) |
| Wheel-hop rear | 26.90 Hz | sqrt((k_sr + k_t)/m_usr) / (2π) |
| Pitch | ~4.4 Hz | (a²·k_f_axle + b²·k_r_axle) / I_yy |
| Roll | ~4.9 Hz | (k_phi_f + k_phi_r) / I_xx, including ARB |
| Yaw | ~1–2 Hz | depends on tyre cornering stiffness and speed |

A consistent ride-mode reading would mean the lumped-corner ride physics survived the addition of the longitudinal / lateral / yaw EOMs. The wider 7-DoF shaker rig already demonstrated this in isolation; this study is the cross-check for the combined 14-DoF.

## To run

```matlab
>> startup_project
>> run('02_data/parameters/Complete_vehicle_simulation_dof14_model_parameters.m')
% inject the chirp on the road inputs (see chirp_input.m — planned)
>> sim('Complete_vehicle_simulation_dof14_model')
% post-process: see post_fft.m (planned, uses the same fft_VD helper as the 7-DoF shaker)
```

Save figures into `../../figures/` with names `fig_freq_*`.

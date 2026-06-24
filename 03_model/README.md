# 03_model — Simulink model anatomy

The single `.slx` file in this folder is the 14-DoF model. The subsystems are arranged in three columns:

| Column | Subsystem | Role |
|---|---|---|
| Inputs | Driver inputs | Throttle, brake, steering wheel angle. Scripted as a function of time. |
| | Road profile | Per-corner vertical road displacement `z_road_FL/FR/RL/RR`. Set to zero for handling studies. |
| | Ambient | Air density, optional wind. |
| Forces | Spring | Per-corner static preload + dynamic spring force. Outputs `F_s_FL/FR/RL/RR`. |
| | Damper | Per-corner damper rate × relative velocity. Outputs `F_d_*`. |
| | Tyre vertical | Static tyre force + dynamic tyre stiffness × (road - z_us). Outputs `F_t_*`. |
| | Tyre Pacejka | Per-tyre lateral force from slip angle, longitudinal force from slip ratio, combined-slip via friction-circle factor. |
| | ARB | Front and rear anti-roll-bar torques (function of roll angle and L-R unsprung displacement difference). |
| | Aero | Downforce (acts on z_s EOM) and drag (acts on x EOM). |
| | Drivetrain | Engine map → gearbox → driveline split → wheel torque per driven wheel. |
| | Brake | Pedal → brake torque, split front/rear by balance. Negative torque on each wheel. |
| Bodies | Sprung mass (3 DoF) | Heave, pitch, roll EOMs. Outputs `z_s`, `theta`, `phi` and their derivatives. |
| | Sprung mass (3 DoF) | x, y, yaw EOMs. Outputs vehicle position and `psi`. |
| | Unsprung mass × 4 | Per-corner vertical EOM. Outputs `z_us_*` and derivatives. |
| | Wheel rotation × 4 | `Iwheel · omega_dot = T_drive - T_brake - F_x · r`. Outputs `omega_*`. |

Outputs are exposed via `To Workspace` blocks named to match the state ordering in [`01_references/14dof_reference.md`](../01_references/14dof_reference.md).

## Caveat

The wiring on the **lateral-load-transfer brackets** in the unsprung-mass EOMs is currently under audit (see `00_admin/02_known_caveats.md` C-001). The vertical / ride physics is solid; the lateral / yaw response is qualitatively right but not calibrated.

## Solver settings

- Fixed-step: 0.001 s (1 kHz)
- Solver: ode4 (Runge-Kutta)
- Stop time: per-study (typically 5–30 s)

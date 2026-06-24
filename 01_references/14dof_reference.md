# 14-DoF model — equation reference

This document is the EOM-by-EOM reference for the Simulink model in `03_model/`. It exists so the model can be audited without opening every subsystem block.

## State vector

```
q = [ z_s   theta   phi   x   y   psi          // 6 body DoFs
      z_us_FL  z_us_FR  z_us_RL  z_us_RR        // 4 unsprung vertical
      omega_FL omega_FR omega_RL omega_RR ]'    // 4 wheel rotational
```

Velocities `qd` follow the same ordering. State length = 28 (14 positions + 14 velocities) in the standard first-order Simulink integration.

## Sign conventions

- `z_s` positive up
- `theta` (pitch) positive = nose down
- `phi` (roll) positive = right side down
- `psi` (yaw) positive = nose left (right-hand rule, z up)
- Spring deflection positive in compression: `def_corner = z_us - z_s ± a·theta ± phi·t/2` per assignment EOMs
- Tyre force positive upward (tyre pushes the wheel up); static tyre force supports `m_s_corner·g + m_us·g` at equilibrium

## Sprung-mass EOMs (3 vertical DoFs from the shaker side)

Vertical:
```
F_s_FL + F_s_FR + F_s_RL + F_s_RR + (damper sum) - m_s·g - F_DF = m_s · zs_dd
```

Pitch:
```
-a·(F_s_FL + F_s_FR + F_d_FL + F_d_FR) + b·(F_s_RL + F_s_RR + F_d_RL + F_d_RR) = Iyy · theta_dd
```

Roll:
```
(F_s_FL - F_s_FR + F_d_FL - F_d_FR)·tf/2
+ (F_s_RL - F_s_RR + F_d_RL - F_d_RR)·tr/2
+ m_s·a_y·(h_COG - h_RC)
- (Gamma_ARB_f + Gamma_ARB_r)
= Ixx · phi_dd
```

## Unsprung-mass vertical EOMs (4 DoFs)

For each corner (FL shown — others differ in sign on the load-transfer bracket and which spring/damper):
```
F_t_FL - F_s_FL - F_d_FL - m_us_f·g + [Gamma_ARB_f + m_s·b/L·a_y·h_RC_f + 2·m_us_f·a_y·h_USM_f] / tf
= m_us_f · z_us_FL_dd
```

The sign of the bracket flips between left and right corners; this is the term currently under audit (C-001 in `00_admin/02_known_caveats.md`).

## Body planar EOMs (handling — x / y / yaw)

```
m·(x_dd - y_d·psi_d)  = Σ F_x_tyres - F_drag
m·(y_dd + x_dd·psi_d) = Σ F_y_tyres
Izz · psi_dd           = Σ moments about CoG from per-tyre F_x and F_y
```

Per-tyre `F_x` and `F_y` come from the Pacejka block (combined-slip Magic Formula with the front/rear coefficient set listed below).

## Wheel rotation (4 DoFs)

For each wheel:
```
Iwheel · omega_dot = T_drive - T_brake - F_x_tyre · r
```

`T_drive` is sourced from the engine map → gearbox → driveline split (front/rear depending on configuration). `T_brake` is the pedal-pressure-to-torque ratio scaled by the front/rear balance.

## Spring forces (with static preloads)

```
F_s_FL = F_0_FL + k_sf·(z_us_FL - z_s + theta·a - phi·tf/2),    F_0_FL = m_s·g·b/L · 1/2
F_s_FR = F_0_FR + k_sf·(z_us_FR - z_s + theta·a + phi·tf/2),    F_0_FR = m_s·g·b/L · 1/2
F_s_RL = F_0_RL + k_sr·(z_us_RL - z_s - theta·b - phi·tr/2),    F_0_RL = m_s·g·a/L · 1/2
F_s_RR = F_0_RR + k_sr·(z_us_RR - z_s - theta·b + phi·tr/2),    F_0_RR = m_s·g·a/L · 1/2
```

Preloads cancel gravity at the sprung-mass equation when q = 0, so the model starts at equilibrium.

## ARB torques

```
Gamma_ARB_f = k_ARB_f · (phi - (z_us_FL - z_us_FR) / tf)
Gamma_ARB_r = k_ARB_r · (phi - (z_us_RL - z_us_RR) / tr)
```

## Tyre vertical force

```
F_t_corner = F_t0_corner + k_tyre · (z_road_corner - z_us_corner)
F_t0_FL = m_s·g·b/L·1/2 + m_us_f·g    (and similar for the other corners)
```

`F_t0` is the static tyre force at equilibrium — it carries the full corner weight (sprung + unsprung).

## Pacejka Magic Formula — per axle

```
Front:  F_y = D · sin( C_f · atan( B_f · alpha - E_f · (B_f · alpha - atan(B_f · alpha)) ) )
Rear:   F_y = D · sin( C_r · atan( B_r · alpha - E_r · (B_r · alpha - atan(B_r · alpha)) ) )
```

with peak `D = (a1·F_z + a2)·F_z` (load-sensitive μ approximation).

Coefficients in `02_data/parameters/Complete_vehicle_simulation_dof14_model_parameters.m`:
- Front: `C_f = 1.2947`, `B_f = 0.0813`, `E_f = -8.3966`
- Rear: `C_r = 1.2617`, `B_r = 0.0925`, `E_r = -8.7012`
- Peak coefficients: `a1 = -1e-5`, `a2 = 0.95`

The intentional front/rear asymmetry is what gives the model a non-trivial understeer characteristic.

## Aerodynamics

```
F_DF   = 0.5 · rho · A · C_z · V^2      (downforce, applied at the CoG vertical equation)
F_drag = 0.5 · rho · A · C_d · V^2      (drag, applied at the longitudinal equation)
```

With `rho = 1.225`, `A = 1.25`, `C_z = 1.00`, `C_d = 0.40`.

## Drivetrain

8-speed sequential gearbox with the gear ratios in the parameter file. The engine map is a 5-throttle × 15-rpm normalised lookup; the absolute torque is `T_eng = T_eng_max · enginemap(throttle, rpm)`. Up-shift at 13 500 rpm, down-shift at 7 000 rpm.

## Brakes

Pedal position → brake torque ratio = 3 800 Nm/m. Front/rear balance = 0.65 / 0.35. Brake torque applied directly to the wheel-rotation EOM (negative T_brake reduces ω).

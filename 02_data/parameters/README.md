# 02_data/parameters

`Complete_vehicle_simulation_dof14_model_parameters.m` is the single source of truth for the vehicle's parameter set. Run it from the MATLAB command window before opening the Simulink model — it pushes every parameter into the base workspace where the model picks them up.

Sections inside the file:
- Constants (`g`)
- Mass and inertia (m, m_us, I_xx, I_yy, I_zz)
- Dimensions (wheelbase, CoG, tracks, wheel radius, roll-centre heights)
- Aero (A, C_z, C_d, ρ)
- Suspension (springs, dampers, tyre vertical stiffness, ARBs)
- Static tyre compressions at equilibrium (`z0t_*`)
- Pacejka coefficients (front and rear separately)
- Steering ratio
- Brake system (pedal-to-torque, balance, wheel inertia, radius)
- Powertrain (gear ratios, engine map grid + values, idle / limit / shift rpm)

If you want a different vehicle (road car), duplicate this file as `road_car_parameters.m`, adjust the values, and load it instead. Don't edit this file in place — that breaks the formula-class baseline that the studies are calibrated against.

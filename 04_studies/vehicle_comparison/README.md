# Vehicle comparison — handling response

**Question.** How does the same handling manoeuvre play out on two very different cars driven by the same model?

**Manoeuvre.** Steering-angle ramp + step (or a single-period sine, depending on which sub-study) at constant throttle. No road irregularities.

**Configurations.**
| Param | Formula-class default | Road car |
|---|---|---|
| Mass m | 850 kg | 1 650 kg |
| Wheelbase L | 3.5 m | 2.8 m |
| CoG height h | 0.20 m | 0.55 m |
| Aero C_z | 1.00 | ~0 |
| Front / rear spring | 67.5 / 100 kN/m | 25 / 30 kN/m |
| Front / rear ARB | 5 000 / 1 000 Nm/rad | 700 / 400 Nm/rad |
| Pacejka set | Race slick | Road tyre |

**Channels.**
- Steering wheel angle (input — same for both cars)
- Yaw rate `psi_dot`
- Lateral acceleration `a_y`
- Side-slip angle `beta`
- X / Y vehicle trajectory
- Roll angle `phi` (the road car will show much more body roll)

**Expected reading.** The formula car reaches higher steady-state yaw rate and lateral acceleration for the same steering input, with a noticeably faster yaw build-up and much smaller body roll. The road car will be visibly understeering at the higher lateral accelerations once the front Pacejka curve has saturated.

## To run

```matlab
>> startup_project
% Run twice — once with the default parameter file, once with the road-car parameter set
>> run('02_data/parameters/Complete_vehicle_simulation_dof14_model_parameters.m')
>> sim('Complete_vehicle_simulation_dof14_model')       % store as out_formula
% swap to road-car params (see road_car_params.m — planned)
>> sim('Complete_vehicle_simulation_dof14_model')       % store as out_road
% overlay channels: see compare_vehicles.m (planned)
```

Save figures into `../../figures/` with names `fig_vehicle_*`.

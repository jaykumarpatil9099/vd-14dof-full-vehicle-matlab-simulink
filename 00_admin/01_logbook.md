# Logbook — 14-DoF full-vehicle model

Append-only. Newest entry at the top. Each entry has four fixed blocks:
**Done** (what changed), **Found** (what the data showed), **Think** (interpretation), **Next** (the brief for the following session).

Commit-message convention: `<type>: <summary> (<quantified result>)` where `<type>` ∈ `{feat, fix, refactor, test, docs, study, params, log}`.

---

## 2026-06-25 — repo extraction

**Done.** Pulled the 14-DoF model and its parameter file out of the wider [`vehicle-dynamics-models-matlab-simulink`](https://github.com/jaykumarpatil9099/vehicle-dynamics-models-matlab-simulink) toolkit into this standalone repo. Built the folder tree (numbered phases mirroring the lap-simulator project), added a README, charter, this logbook, the known-caveats list, and the equation reference.

**Found.** Nothing functional changed — same `.slx`, same parameter file as the toolkit. The standalone framing makes it easier to talk about the 14-DoF in isolation in interviews, where dragging in five other models is noise.

**Think.** The known-caveats list (`02_known_caveats.md`) is now the single source of truth for what's still open. The two follow-on items are: (1) audit the lateral-load-transfer brackets and sign convention against the assignment EOMs, (2) re-run the three studies into `figures/` from a clean session to capture the current state of the plots.

**Next.** Open `03_model/Complete_vehicle_simulation_dof14_model.slx`, walk the roll-equation block by hand against `01_references/14dof_reference.md`, log any sign mismatches into the caveats list.

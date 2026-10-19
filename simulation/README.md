# Simulation

- `run_main.m`: main symbolic analysis and animation.
- `run_bonus.m`: new synthesis problem and animation.
- `cam_model.m`: symbolic derivation, motion, pitch curve and roller offset.
- `validate_cam.m`: assertions and numerical geometric checks.
- `render_cam.m`: visible mechanism, displacement plot, PNG and AVI.

Run `RUN_ALL.m` in the repository root for both tasks and a diagnostic ZIP. Requires MATLAB with Symbolic Math Toolbox. Uses only MATLAB base routines besides symbolic operations; no Optimization Toolbox or Simscape required. Actual version compatibility awaits the first MATLAB run. Parameters are in the two entry functions; the synthesis uses a 30-degree pressure limit and the six-stage schedule listed in the root README.

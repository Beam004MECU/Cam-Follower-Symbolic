# Simulation

- `run_main.m`: main symbolic analysis and animation.
- `run_bonus.m`: new synthesis problem and animation.
- `cam_model.m`: symbolic derivation, motion, pitch curve and roller offset.
- `validate_cam.m`: assertions, derivatives in every stage and numerical geometric checks.
- `recover_lift.m`: independently reconstruct follower lift from the complete polygonal cam surface.
- `render_cam.m`: visible mechanism, displacement/velocity/acceleration plots, PNG and AVI.

Run `RUN_ALL.m` in the repository root for both tasks and a diagnostic ZIP. Requires MATLAB with Symbolic Math Toolbox. Uses only MATLAB base routines besides symbolic operations; no Optimization Toolbox or Simscape required. The previous revision was run in MATLAB R2026a Update 4 with Symbolic Math Toolbox 26.1 on 19 October 2026. Validation revision 2 has passed independent Python checks; its MATLAB execution and updated UI still require a fresh run. Parameters are in the two entry functions; the synthesis uses a 30-degree pressure limit and the six-stage schedule listed in the root README.

`install_cam_controls.m` adds nonblocking Play/Pause and Reset after recording. RUN_ALL enables controls only after both cases and the result ZIP are complete. Closing a figure stops and deletes only its own timer. Interactive playback does not append to the AVI.

The returned ZIP now contains the source snapshot and sampled MATLAB motion/profile arrays. `validationVersion=2` identifies the new numerical checks. Physical velocity and acceleration use the fixed input speed, not the playback speed multiplier.

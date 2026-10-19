# Verification status

**MATLAB runtime status: NOT YET EXECUTED.** No claim is made that MATLAB has passed. `RUN_ALL.m` collects actual MATLAB version, logs, results and AVI files into a timestamped ZIP. Send that ZIP even if an error occurs. Each run uses a new result directory so old successes cannot mask a failed run.

Independent NumPy/SciPy calculation (`check_reference.py`) checks the main case and the revised stepped synthesis:

| Case | Max lift mm | Rb mm | max abs pressure deg | min convex pitch radius mm |
|---|---:|---:|---:|---:|
| Main | 20 | 40 | 25.142615 | 35.467560 |
| Stepped synthesis continuous bound | 25 | 33.385049 | 29.999997 | 22.024396 |
| Stepped synthesis selected | 25 | 33.5 | 29.941155 | 22.103413 |

The independent check confirms both dwell levels, the return and the derivative residuals (below 3.5e-8). The sampled interference gap is within floating-point roundoff of zero. Geometry uses 14401 profile points and 361 roller positions; this does not prove absence of interference at every possible point or validate forces.

Reproduce using Python with NumPy, SciPy and Matplotlib: `python experiments/check_reference.py`. It generates `reference_results.json` and `media/stepped_synthesis.png`. The main links/joints illustration remains the unchanged main design.

## Pending MATLAB checks

1. Run `RUN_ALL.m` with Symbolic Math Toolbox; record actual MATLAB version.
2. Confirm both animation windows display correctly and both AVI files play.
3. Inspect `RUN_COMPLETE.txt` or `ERROR_REPORT.txt`, compare MAT results with the table above.
4. Only after reviewing the actual results change the project status to validated in MATLAB.

## Interactive playback check (pending MATLAB run)

After RUN_ALL completes, press Play in each figure, Pause and Resume without a jump, Reset to angle zero, and close each figure. Confirm the other figure remains usable and no timer errors appear. AVI recording remains finite (three cycles each); playback controls do not modify saved video or numerical results.

Playback speed revision: verify 0.1x, 0.25x (default), 0.5x, 1x and 2x while playing and paused; changing speed should preserve the displayed angle. Playback speed affects wall-clock display only, not the mechanism design or saved AVI. This UI revision awaits MATLAB validation.

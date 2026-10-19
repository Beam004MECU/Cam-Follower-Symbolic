# Experiments

## Test record

- **Objective:** Verify symbolic kinematics, stepped-lift synthesis, geometry and recorded animation.
- **Date / operator:** 2026-10-19 / Phurinat Chaikaow.
- **Setup / equipment:** MATLAB R2026a Update 4 with Symbolic Math Toolbox 26.1 on macOS; numerical simulation only.
- **Calibration:** Not applicable; no physical measuring instruments or measurements.
- **Conditions / units:** Constant 60 rpm; prescribed motion schedules in the root README; mm, s and rad internally, degrees for reported angles.
- **Procedure:** Run `RUN_ALL.m` from the repository root, inspect assertions and generated results, then compare against `check_reference.py` as described below.
- **Data:** `matlab_results/` contains saved numerical results and the completion marker, not physical raw measurements; `reference_results.json` contains processed independent-check results.

## Verification status

Both cases passed the assertions in an actual MATLAB run on 19 October 2026, using MATLAB R2026a Update 4 and Symbolic Math Toolbox 26.1 on macOS. `RUN_COMPLETE.txt` reports: "Both tasks completed with all assertions passing." No error report was produced.

The returned MAT results agree with the independent reference for base radius, maximum pressure angle and minimum convex pitch radius to within 1e-8 in the reported units. Both returned AVI files contain 90 frames at 30 fps (3 seconds, three revolutions). Sample frames at 60, 180 and 300 degrees were reviewed for the mechanism and displacement marker. The user also confirmed interactive playback and speed controls operate; every UI state was not independently instrumented.

Raw runtime logs are excluded because they contain machine and license information. The numerical result files and completion marker are included under `matlab_results/`; videos and rendered images are under `media/`.

Independent NumPy/SciPy calculation (`check_reference.py`) checks the main case and the revised stepped synthesis:

| Case | Max lift mm | Rb mm | max abs pressure deg | min convex pitch radius mm |
|---|---:|---:|---:|---:|
| Main | 20 | 40 | 25.142615 | 35.467560 |
| Stepped synthesis continuous bound | 25 | 33.385049 | 29.999997 | 22.024396 |
| Stepped synthesis selected | 25 | 33.5 | 29.941155 | 22.103413 |

The independent check confirms both dwell levels, the return and the derivative residuals (below 3.5e-8). The sampled interference gap is within floating-point roundoff of zero. Geometry uses 14401 profile points and 361 roller positions; this does not prove absence of interference at every possible point or validate forces.

Reproduce using Python with NumPy, SciPy and Matplotlib: `python experiments/check_reference.py`. It generates `reference_results.json` and `media/stepped_synthesis.png`. The main links/joints illustration remains the unchanged main design.


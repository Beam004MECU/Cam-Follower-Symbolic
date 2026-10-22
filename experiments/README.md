# Experiments

## Test record

- **Objective:** Verify symbolic kinematics, stepped-lift synthesis, geometry and recorded animation.
- **Date / operator:** 2026-10-19 / Phurinat Chaikaow.
- **Setup / equipment:** MATLAB R2026a Update 4 with Symbolic Math Toolbox 26.1 on macOS; numerical simulation only.
- **Calibration:** Not applicable; no physical measuring instruments or measurements.
- **Conditions / units:** Constant 60 rpm; prescribed motion schedules in the root README; mm, s and rad internally, degrees for reported angles.
- **Procedure:** Run `RUN_ALL.m` from the repository root, inspect assertions and generated results, then compare against `check_reference.py` as described below.
- **Data:** `matlab_results/` contains saved numerical results and the completion marker, not physical raw measurements; `reference_results.json` contains processed independent-check results.

## Previous MATLAB run (19 October 2026)

Both cases in the previous source revision passed the assertions in an actual MATLAB run on 19 October 2026, using MATLAB R2026a Update 4 and Symbolic Math Toolbox 26.1 on macOS. `RUN_COMPLETE.txt` reports: "Both tasks completed with all assertions passing." No error report was produced.

The returned MAT results agree with the independent reference for base radius, maximum pressure angle and minimum convex pitch radius to within 1e-8 in the reported units. Both returned AVI files contain 90 frames at 30 fps (3 seconds, three revolutions). Sample frames at 60, 180 and 300 degrees were reviewed for the mechanism and displacement marker. The user also confirmed interactive playback and speed controls operate; every UI state was not independently instrumented.

Raw runtime logs are excluded because they contain machine and license information. The numerical result files and completion marker are included under `matlab_results/`; videos and rendered images are under `media/`.

## Revision 2 checks (23 October 2026)

The updated MATLAB source has **not yet been executed in MATLAB**. The saved MAT files, completion marker, PNGs and AVIs above belong to the previous revision; they do not certify the new checks or three-plot UI.

Changes: use `phiLimit` in both symbolic synthesis expressions; check numerical derivatives at three interior points of every stage; reconstruct lift from all polygon edges independently of the motion law; export sampled motion and profile arrays plus a source snapshot. The renderer shows physical s, v and a using 60 rpm, with synchronized markers. Playback speed still only changes playback timing.

Independent NumPy/SciPy calculation (`check_reference.py`) passes for the main case and stepped synthesis:

| Case | Max lift mm | Rb mm | max abs pressure deg | min convex pitch radius mm |
|---|---:|---:|---:|---:|
| Main | 20 | 40 | 25.142615 | 35.467560 |
| Stepped synthesis continuous bound | 25 | 33.385049 | 29.999997 | 22.024396 |
| Stepped synthesis selected | 25 | 33.5 | 29.941155 | 22.103413 |

The independent check confirms both dwell levels, the return and the derivative residuals (below 3.5e-8). The sampled interference gap is within floating-point roundoff of zero. Geometry uses 14401 profile points and 361 roller positions; this does not prove absence of interference at every possible point or validate forces.

Reproduce using Python with NumPy, SciPy and Matplotlib: `python experiments/check_reference.py`. It generates `reference_results.json` and `media/stepped_synthesis.png`. The main links/joints illustration remains the unchanged main design.


The independent surface inversion residual is 0.00000243 mm (main) and 0.00000237 mm (selected synthesis), including 137 off-grid angles. Scaling the surface to 99% while keeping the correct prescribed lift produces errors of 0.600 and 0.585 mm, confirming that the check rejects an incorrect surface. A square profile checks vertical/horizontal edges. Repeating synthesis with limits 25°, 30° and 35° selects Rb=45.0, 33.5 and 25.0 mm respectively; all pass the applicable sampled pressure and curvature checks. These are independent Python results, not MATLAB runtime results.

The actual 1801-point polygon used in the animation is also inverted, with a separate 0.001 mm tolerance. MATLAB syntax/static analysis with MISS_HIT passes for all eight `.m` files; this is not a MATLAB execution. The optional MAT import checker was tested with synthetic valid/corrupted fixtures, not with new MATLAB output.

To close verification, run `RUN_ALL.m` in MATLAB and inspect the new plots and playback. Return the generated `RETURN_TO_REVIEW_*.zip`; the result must include `validationVersion=2`, source files, and the new sampled arrays. After extracting that ZIP, independently compare its actual MATLAB arrays with:

```bash
python experiments/check_reference.py --matlab-dir /path/to/extracted/run
```

Only a successful new MATLAB run and comparison can replace the historical MATLAB evidence and mark this revision as runtime-verified.

# Verification status

**MATLAB runtime status: NOT YET EXECUTED.** No claim is made that MATLAB has passed. `RUN_ALL.m` collects actual MATLAB version, logs, results and AVI files into a timestamped ZIP. Send that ZIP even if an error occurs. Each run uses a new result directory so old successes cannot mask a failed run.

Independent NumPy/SciPy calculation (`check_reference.py`) checked both designs and the continuous bonus bound:

| Case | Lift mm | Rb mm | max abs pressure deg | min convex pitch radius mm |
|---|---:|---:|---:|---:|
| Main | 20 | 40 | 25.142615 | 35.467560 |
| Bonus continuous pressure bound | 30 | 47.528336 | 29.999999 | 41.823295 |
| Bonus selected | 30 | 48 | 29.820448 | 42.170898 |

The sampled global interference gap is within 2e-14 mm of zero (floating-point roundoff). The largest checked derivative residual is below 2.3e-8 in mm/rad or mm/rad². Geometry uses 14401 profile points and 361 roller positions. This is a numerical verification, not proof at all possible points or a test of real contact dynamics.

To reproduce this independent check: Python with NumPy, SciPy and Matplotlib; run `python experiments/check_reference.py` from the repository root. It also regenerates `media/links_joints.png`.

## Pending MATLAB checks

1. Run `RUN_ALL.m` with Symbolic Math Toolbox; record actual MATLAB version.
2. Confirm both animation windows display correctly and both AVI files play.
3. Inspect `RUN_COMPLETE.txt` or `ERROR_REPORT.txt`, compare MAT results with the table above.
4. Only after reviewing the actual results change the project status to validated in MATLAB.

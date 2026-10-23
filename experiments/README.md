# Experiments

Revision 2 passed an actual MATLAB run and independent comparison on **23 October 2026** for both Main and Synthesis.

## Runtime evidence

- Executed in MATLAB with Symbolic Math Toolbox; machine and license details are excluded.
- Accepted run: `RETURN_TO_REVIEW_20261023_221455.zip`; the earlier `221141` run also passed with identical numerical results.
- Both runs contain `validationVersion=2`, source snapshots, sampled motion/profile arrays and `RUN_COMPLETE.txt`; neither contains `ERROR_REPORT.txt`.
- All eight source files match the repository MATLAB source byte-for-byte. Source, archive and evidence hashes are recorded in [verification.json](matlab_results/verification.json).
- Saved MAT files and the completion marker are in `matlab_results/`; PNG exports and resized/recompressed AVI copies are in `../media/`. These replace the 19 October evidence. Raw logs are excluded because they contain machine/license information.

| Case | Max lift mm | Rb mm | Max abs pressure deg | Min convex pitch radius mm |
|---|---:|---:|---:|---:|
| Main | 20 | 40 | 25.142615 | 35.467560 |
| Synthesis | 25 | 33.5 | 29.941155 | 22.103413 |

Synthesis gives a continuous pressure-angle bound of 33.385049127 mm, rounded upward in 0.5 mm steps to 33.5 mm. Its critical points and stage bounds agree with independent calculation. Both cases satisfy the 30° pressure limit and 7 mm convex pitch-radius threshold.

## Independent comparison

With Python, NumPy, SciPy and Matplotlib installed, run from the repository root:

```bash
python experiments/check_reference.py --matlab-dir experiments/matlab_results
```

For an extracted returned ZIP, pass its extraction directory instead. The checker supports both the returned `main/result.mat`, `bonus/result.mat` layout and the stored `main_result.mat`, `bonus_result.mat` layout.

Both returned archives passed the checker: all four motion rows and both cam coordinates at 14,401 angles agree within 1e-8. Observed maximum differences are 1.14e-13 for motion derivatives and 2.14e-14 mm for cam coordinates. Independent inversion of the returned surface also passes the 1e-4 mm tolerance. MATLAB reports surface lift residuals of 2.43e-6 mm (Main) and 2.37e-6 mm (Synthesis); the actual 1,801-point display polygons pass their separate 0.001 mm tolerance. Aggregate and per-case MAT arrays agree.

The independent suite also checks derivatives, joins, dwell levels, surface inversion with off-grid angles, deliberately corrupted surfaces, and pressure limits of 25°, 30° and 35°. Those alternate pressure-limit cases are Python tests, not additional MATLAB runs.

All four original returned AVIs decode completely: 90 frames at 30 fps, three seconds and three revolutions. Frames at 60°, 180° and 300° from the accepted run were reviewed for mechanism contact and synchronized s/v/a markers. Saved PNGs precede recording and playback controls; controls appear afterward in the live figures. The two published AVI copies are resized to 1150 × 780 and recompressed as MPEG-4; both decode completely and retain all 90 frames, 30 fps and three-second duration. Not every interactive UI state was instrumented.

## Scope

This verifies the submitted revision's symbolic kinematics, sampled geometry, synthesis and recorded output. Geometry checks use 14,401 profile points and 361 roller positions; finite sampling is not a proof for every possible point. No physical measurements, forces, strength or loss-of-contact dynamics were tested. Independent Python/static checks alone do not establish MATLAB execution; the returned revision 2 runtime evidence above supplies that evidence here.

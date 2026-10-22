# Model and synthesis

Units: mm, s, rad (degrees only for display). Cam input is positive clockwise; fixed axes x right and y up. Let r=Rb+Rr+s. The pitch curve in cam coordinates is p=(-r sinθ, r cosθ). Its outward unit normal is (p′y,−p′x)/|p′|. The cam surface is c=p−Rr n. Rotate c clockwise through θ for the displayed moving cam. The roller center is (0,r).

Pressure angle: φ=atan2(sθ,r). Signed pitch curvature:

$$\kappa_p=\frac{r^2+2s_\theta^2-rs_{\theta\theta}}{(r^2+s_\theta^2)^{3/2}}.$$

Regularity requires 1−Rr κp>0. On convex parts, ρcam=ρpitch−Rr. Negative curvature is concavity, not automatically a failure. The 2 mm convex curvature allowance is a design input, not a strength safety factor.

## Stepped-lift synthesis

Schedule: 0–60°: 0→10 mm; 60–100°: dwell 10 mm; 100–180°: 10→25 mm; 180–220°: dwell 25 mm; 220–320°: 25→0 mm; 320–360°: dwell 0 mm.

For each moving stage define u=(θ−θstart)/β and s=s0+ΔF(u), where F is the symbolic cycloidal law. At both ends F′=F″=0, so s, velocity and acceleration join continuously with adjacent dwells. Jerk can jump finitely.

Let φlim be the configured pressure limit (30° for the submitted design). The pressure constraint requires B(u)=|Δ|F′/(βtanφlim)−Rr−s0−ΔF. Differentiation gives B′=0 at the single interior point

```math
u_* = \frac{\operatorname{atan2}(2\pi,\operatorname{sgn}(\Delta)\beta\tan\phi_{lim})}{\pi}.
```

This follows by factoring sin(πu) from F″−sgn(Δ)βtanφlim F′. The derivative changes from positive to negative at this point. Evaluate endpoints and this root for EVERY rise and fall; no rise/return symmetry is assumed for this schedule. Dwells have zero pressure angle.

The three stage bounds are 23.385087, 15.323960 and 33.385049 mm; the return governs. Select Rb=33.5 mm. The continuous pressure minimum and rounded design both pass the numerical curvature and interference checks. The minimum sampled convex pitch radius is 22.103413 mm for the rounded design. These curvature/interference checks are numerical, not continuous mathematical proofs.

The main task remains a prescribed Rb=40 mm, h=20 mm design. The synthesis solves the new motion schedule; it does not hardcode the answer.

## Verification from the surface

`recover_lift.m` uses only cam polygon vertices, roller radius and cam angle. After rotating the polygon clockwise, the lowest nonpenetrating roller center above the cam is

```math
y_c=\max_{(x,y)\in\mathrm{surface},\ |x|\le R_r}\left(y+\sqrt{R_r^2-x^2}\right),\qquad s_{recovered}=y_c-R_b-R_r.
```

The maximum is evaluated on every edge, including endpoints and vertical edges; it is not restricted to the designed contact point. On an edge with slope m, the interior candidate is x=Rr m/sqrt(1+m²), clipped to the edge within the roller strip. Compare the reconstructed lift with the prescribed schedule at grid, off-grid and boundary angles. The 14401-point surface uses a 1e-4 mm tolerance for polygon approximation. This is a numerical kinematic check under the maintained-contact assumption.

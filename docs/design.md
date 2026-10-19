# Model and synthesis

Units: mm, s, rad (degrees only for display). Cam input is positive clockwise; fixed axes x right and y up. Let r=Rb+Rr+s. The pitch curve in cam coordinates is p=(-r sinθ, r cosθ). Its outward unit normal is (p′y,−p′x)/|p′|. The cam surface is c=p−Rr n. Rotate c clockwise through θ for the displayed moving cam. The roller center is (0,r).

Pressure angle: φ=atan2(sθ,r). Signed pitch curvature:

$$\kappa_p=\frac{r^2+2s_\theta^2-rs_{\theta\theta}}{(r^2+s_\theta^2)^{3/2}}.$$

Regularity requires 1−Rr κp>0. On convex parts, ρcam=ρpitch−Rr. Negative curvature is concavity, not automatically a failure. The 2 mm convex curvature allowance is a design input, not a strength safety factor.

## Bonus pressure-angle minimum

For the cycloidal rise, F′=1−cos(2πu), F″=2πsin(2πu). Let c=βtanφlimit. Then B′ is proportional to 2πsin(2πu)−c[1−cos(2πu)]. In 0<u<1 its only stationary root is

$$u_* = \frac{1}{\pi}\tan^{-1}\left(\frac{2\pi}{\beta\tan\phi_{\max}}\right).$$

The derivative changes from positive to negative there. Evaluate u=0,u*,1. Symmetry F(1−u)=1−F(u) and F′(1−u)=F′(u) gives the same pairs (s,|sθ|) during return; dwell has zero pressure angle. Thus this bound covers the whole cycle. For this stated design the pressure-angle solution also passes the sampled curvature check. Curvature and global interference tests remain numerical checks, not continuous mathematical proofs. The code stops if these checks fail; it does not claim a general optimizer for arbitrary motion laws or constraints.

The main task uses an explicitly prescribed Rb=40 mm. The bonus uses a new h=30 mm and calculates Rb; it does not hardcode the final design.

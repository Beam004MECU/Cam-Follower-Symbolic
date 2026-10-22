function result=validate_cam(model,phiLimit,margin)
% Numerical geometric verification; does not validate contact forces.
th=linspace(0,2*pi,14401); G=model.geometry(th); Y=model.motion(th);
assert(all(isfinite([G.x G.y G.phi G.kappa])),'Nonfinite geometry.');
assert(min(Y(1,:))>=-1e-9 && max(Y(1,:))<=model.h+1e-9,'Lift bounds.');
assert(max(abs(G.phi))<=phiLimit+1e-7,'Pressure angle exceeds limit.');
assert(min(G.regularity)>0,'Singular normal-offset curve.');
positive=G.kappa(G.kappa>0); rhoMin=1/max(positive);
assert(rhoMin>=model.rr+margin-1e-7,'Convex curvature margin failed.');
offset=hypot(G.x-G.pitchX,G.y-G.pitchY);
assert(max(abs(offset-model.rr))<1e-9,'Offset distance mismatch.');
% Verify roller does not intersect a remote sampled part of the cam surface.
minGap=inf;
for angle=linspace(0,2*pi,361)
    lift=model.motion(angle); center=model.rb+model.rr+lift(1);
    cx=-center*sin(angle); cy=center*cos(angle);
    minGap=min(minGap,min(hypot(G.x-cx,G.y-cy))-model.rr);
end
assert(minGap>=-1e-6,'Sampled global roller interference.');
% Independent central differences away from event boundaries.
% Three interior points in EVERY stage, including all dwells and rises/fall.
stages=model.schedule;
t=reshape((stages(:,1)+(stages(:,2)-stages(:,1))*[0.2 0.5 0.8])'*pi/180,1,[]);
dt=1e-5;
Ya=model.motion(t); Yp=model.motion(t+dt); Ym=model.motion(t-dt);
velocityResidual=max(abs((Yp(1,:)-Ym(1,:))/(2*dt)-Ya(2,:)));
accelerationResidual=max(abs((Yp(2,:)-Ym(2,:))/(2*dt)-Ya(3,:)));
assert(velocityResidual<1e-6 && accelerationResidual<1e-6,'Derivative check.');
% Explicit left/right checks at every event boundary, including full-cycle wrap.
joinAngles=model.schedule(:,1)'*pi/180;
joinValues=model.schedule(:,3)';
for side=[-1 0 1]
    check=model.motion(joinAngles+side*1e-10);
    assert(max(abs(check(1,:)-joinValues))<1e-7,'Discontinuous stage position.');
    assert(max(max(abs(check(2:3,:))))<1e-5,'Discontinuous stage velocity/acceleration.');
end
% Invert the actual polygonal surface; do not reuse the prescribed lift.
angles=unique([linspace(0,2*pi,361) (0:136)*2*pi/137+0.00123 t joinAngles]);
recovered=recover_lift(G.x,G.y,model.rr,model.rb,angles);
expected=model.motion(angles);
surfaceLiftResidual=max(abs(recovered-expected(1,:)));
% A finite polygon approximates the smooth surface; tolerance is in mm.
assert(surfaceLiftResidual<1e-4,'Surface does not reproduce prescribed lift.');
% The displayed/recorded patch uses a coarser polygon; check it separately.
renderG=model.geometry(linspace(0,2*pi,1801));
renderLift=recover_lift(renderG.x,renderG.y,model.rr,model.rb,angles);
renderResidual=max(abs(renderLift-expected(1,:)));
assert(renderResidual<1e-3,'Rendered surface does not reproduce prescribed lift.');
result.renderSurfaceLiftResidual=renderResidual;
result.surfaceLiftResidual=surfaceLiftResidual;
result.validationVersion=2;
% Save the evaluated model so an independent checker can inspect MATLAB output.
result.samples.theta=th;
result.samples.motion=Y;
result.samples.cam=[G.x;G.y];
result.samples.schedule=model.schedule;
result.h=model.h; result.rb=model.rb; result.rr=model.rr;
result.maxPressureDeg=max(abs(G.phi)); result.minPitchRadius=rhoMin;
result.minCamRadius=rhoMin-model.rr; result.minSampledGap=minGap;
result.velocityResidual=velocityResidual; result.accelerationResidual=accelerationResidual;
result.status='Assertions passed in this MATLAB run';
end

function result=run_bonus(outDir, animate)
% Synthesis: NEW lift 30 mm; minimum base radius satisfying pressure angle.
% Curvature is verified numerically afterward, not silently assumed feasible.
if nargin<1, outDir=fullfile(fileparts(mfilename('fullpath')),'results','bonus'); end
if nargin<2, animate=true; end
if ~exist(outDir,'dir'), mkdir(outDir); end
h=30; rr=5; phiLimit=30; margin=2; sizeStep=0.5; rpm=60;
seed=cam_model(h,40,rr); u=seed.u; p=sym(pi); beta=p/2;
% Rb >= B(u) for every u. Stationarity follows from symbolic differentiation.
B=sym(h)*diff(seed.F,u)/(beta*tan(p/6))-sym(rr)-sym(h)*seed.F;
dB=simplify(diff(B,u));
% B'(u)=0 has one interior root: tan(pi*u)=2*pi/(beta*tan(phiLimit)).
uStar=atan(2*p/(beta*tan(p/6)))/p;
assert(abs(double(subs(dB,u,uStar)))<1e-8);
bound=max(double(subs(B,u,[sym(0) uStar sym(1)])));
assert(bound>0,'This design requires a positive pressure-angle bound.');
continuous=cam_model(h,bound,rr);
continuousCheck=validate_cam(continuous,phiLimit,margin);
rb=ceil(bound/sizeStep)*sizeStep;
model=cam_model(h,rb,rr);
result=validate_cam(model,phiLimit,margin);
result.rbContinuous=bound; result.criticalU=double(uStar);
result.rbStep=sizeStep; result.continuousCheck=continuousCheck;
result.task='Bonus: synthesize a 30 mm lift cam';
disp('Symbolic pressure-angle lower-bound function B(u):');disp(B);
fprintf('Continuous Rb = %.9f mm; selected Rb = %.3f mm\n',bound,rb);
disp(result);
render_cam(model,rpm,outDir,'Bonus: synthesized cam',animate);
save(fullfile(outDir,'result.mat'),'result','B','dB','uStar');
end

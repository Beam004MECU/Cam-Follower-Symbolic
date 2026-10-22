function result=run_bonus(outDir, animate, deferPlayback)
% Synthesis: 0 -> 10 -> 25 -> 0 mm, including intermediate dwells.
if nargin<1, outDir=fullfile(fileparts(mfilename('fullpath')),'results','bonus'); end
if nargin<2, animate=true; end
if nargin<3, deferPlayback=false; end
if ~exist(outDir,'dir'), mkdir(outDir); end
schedule=[0 60 0 10;60 100 10 10;100 180 10 25; ...
          180 220 25 25;220 320 25 0;320 360 0 0];
h=25; rr=5; phiLimit=30; margin=2; sizeStep=0.5; rpm=60;
seed=cam_model(h,40,rr,schedule); u=seed.u; p=sym(pi);
assert(phiLimit>0 && phiLimit<90);
phi=sym(phiLimit)*p/180;
B=sym(zeros(3,1)); criticalU=zeros(3,1); segmentBounds=zeros(3,1); j=0;
for k=1:size(schedule,1)
    delta=schedule(k,4)-schedule(k,3);
    if delta==0, continue; end
    j=j+1; beta=sym(schedule(k,2)-schedule(k,1))*p/180;
    % Absolute derivative is positive F' times abs(delta) in each stage.
    B(j)=abs(delta)*diff(seed.F,u)/(beta*tan(phi))-rr-schedule(k,3)-delta*seed.F;
    uStar=atan2(2*p,sign(delta)*beta*tan(phi))/p;
    dB=simplify(diff(B(j),u));
    assert(abs(double(subs(dB,u,uStar)))<1e-8);
    criticalU(j)=double(uStar);
    segmentBounds(j)=max(double(subs(B(j),u,[sym(0) uStar sym(1)])));
end
bound=max(segmentBounds);
continuous=cam_model(h,bound,rr,schedule);
continuousCheck=validate_cam(continuous,phiLimit,margin);
rb=ceil(bound/sizeStep)*sizeStep;
model=cam_model(h,rb,rr,schedule);
result=validate_cam(model,phiLimit,margin);
% Confirm both dwell levels and the return, independently of plotting.
probe=model.motion([80 200 340]*pi/180);
assert(max(abs(probe(1,:)-[10 25 0]))<1e-10);
assert(max(max(abs(probe(2:3,:))))<1e-10);
result.rbContinuous=bound; result.criticalU=criticalU;
result.phiLimit=phiLimit; result.curvatureMargin=margin;
result.rpm=rpm; result.rbStep=sizeStep; result.continuousCheck=continuousCheck;
result.schedule=schedule; result.task='Synthesis: two-level stepped lift';
disp('Symbolic pressure-angle bound for each moving stage:');disp(B);
fprintf('Continuous Rb = %.9f mm; selected Rb = %.3f mm\n',bound,rb);disp(result);
render_cam(model,rpm,outDir,'Synthesis: stepped lift 10 / 25 mm',animate,deferPlayback);
save(fullfile(outDir,'result.mat'),'result','B','criticalU','segmentBounds','schedule');
end

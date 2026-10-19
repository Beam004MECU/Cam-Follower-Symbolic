function result=run_main(outDir, animate, deferPlayback)
% Main assignment: prescribed cam geometry + symbolic kinematics + animation.
if nargin<1, outDir=fullfile(fileparts(mfilename('fullpath')),'results','main'); end
if nargin<2, animate=true; end
if nargin<3, deferPlayback=false; end
if ~exist(outDir,'dir'), mkdir(outDir); end
model=cam_model(20,40,5); rpm=60;
result=validate_cam(model,30,2);
result.rpm=rpm; result.task='Main: prescribed Rb = 40 mm';
disp('Symbolically derived normalized displacement:'); disp(model.F);
disp(result);
render_cam(model,rpm,outDir,'Main: symbolic cam',animate,deferPlayback);
save(fullfile(outDir,'result.mat'),'result');
end

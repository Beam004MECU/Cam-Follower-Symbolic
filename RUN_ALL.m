% Cam and Follower: main analysis and synthesis.
% Requires MATLAB with Symbolic Math Toolbox.
projectRoot=fileparts(mfilename('fullpath'));
addpath(fullfile(projectRoot,'simulation'));
mainResult=run_main(fullfile(projectRoot,'results','main'),true);
bonusResult=run_bonus(fullfile(projectRoot,'results','bonus'),true);

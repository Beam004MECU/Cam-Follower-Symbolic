% Run once from the MATLAB Editor. Requires MATLAB + Symbolic Math Toolbox.
% Produces two visible animations and one ZIP to return for verification.
root=fileparts(mfilename('fullpath'));
oldPath=path; pathCleanup=onCleanup(@()path(oldPath));
addpath(fullfile(root,'simulation'));
stamp=datestr(now,'yyyymmdd_HHMMSS');
resultRoot=fullfile(root,'simulation','results');
if ~exist(resultRoot,'dir'), mkdir(resultRoot); end
runFolder=tempname(resultRoot); mkdir(runFolder);
diary(fullfile(runFolder,'MATLAB_log.txt'));
try
    fprintf('Run: %s\nMATLAB: %s\n',stamp,version);ver;
    mainResult=run_main(fullfile(runFolder,'main'),true);
    bonusResult=run_bonus(fullfile(runFolder,'bonus'),true);
    save(fullfile(runFolder,'results.mat'),'mainResult','bonusResult');
    fid=fopen(fullfile(runFolder,'RUN_COMPLETE.txt'),'w');
    fprintf(fid,'Both tasks completed with all assertions passing.\n');fclose(fid);
catch ME
    report=getReport(ME,'extended','hyperlinks','off');disp(report);
    fid=fopen(fullfile(runFolder,'ERROR_REPORT.txt'),'w');fprintf(fid,'%s',report);fclose(fid);
end
diary off;
archive=fullfile(root,['RETURN_TO_REVIEW_' stamp '.zip']);
zip(archive,{'*'},runFolder);
fprintf('\nSend this ZIP for verification:\n%s\n',archive);

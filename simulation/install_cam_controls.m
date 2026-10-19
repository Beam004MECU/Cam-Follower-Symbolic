function install_cam_controls(fig,updateFrame,omega,initialAngle,enabled)
% Nonblocking playback after finite AVI recording. One timer per figure.
% Timer is created only when Play is pressed; closing the figure deletes it.
if nargin<5, enabled=true; end
controlState='off'; if enabled,controlState='on';end
currentAngle=initialAngle; anchorAngle=initialAngle;
clockStart=[]; playbackTimer=[];
playButton=uicontrol(fig,'Style','pushbutton','String','Play', ...
    'Units','normalized','Position',[.38 .015 .10 .045], ...
    'Callback',@togglePlayback,'Tag','CamPlaybackControl','Enable',controlState);
uicontrol(fig,'Style','pushbutton','String','Reset', ...
    'Units','normalized','Position',[.50 .015 .10 .045], ...
    'Callback',@resetPlayback,'Tag','CamPlaybackControl','Enable',controlState);
set(fig,'DeleteFcn',@disposeTimer);

    function togglePlayback(~,~)
        if isempty(playbackTimer) || ~isvalid(playbackTimer)
            playbackTimer=timer('ExecutionMode','fixedSpacing', ...
                'Period',1/30,'TimerFcn',@tick,'ErrorFcn',@playbackError);
        end
        if strcmp(playbackTimer.Running,'on')
            stop(playbackTimer);
            set(playButton,'String','Play');
        else
            anchorAngle=currentAngle; clockStart=tic;
            set(playButton,'String','Pause');
            start(playbackTimer);
        end
    end

    function tick(~,~)
        if ~isgraphics(fig), return; end
        currentAngle=mod(anchorAngle+omega*toc(clockStart),2*pi);
        updateFrame(currentAngle);
        drawnow limitrate nocallbacks
    end

    function resetPlayback(~,~)
        currentAngle=0; anchorAngle=0; clockStart=tic;
        updateFrame(0);
        drawnow;
    end

    function playbackError(~,~)
        if isgraphics(playButton),set(playButton,'String','Play');end
        warning('cam:PlaybackTimer','Playback stopped because of a timer error.');
    end

    function disposeTimer(~,~)
        if ~isempty(playbackTimer) && isvalid(playbackTimer)
            stop(playbackTimer);delete(playbackTimer);
        end
    end
end

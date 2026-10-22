function render_cam(model,rpm,outDir,label,animate,deferPlayback)
if nargin<6, deferPlayback=false; end
% Every animation coordinate comes from the same symbolic motion model.
% No prescribed roller spin: passive rotation is omitted in the reduced model.
th=linspace(0,2*pi,1801); G=model.geometry(th);
omega=2*pi*rpm/60; maxR=model.rb+model.h; guide=model.rb+2*model.rr+model.h+12;
fig=figure('Name',label,'Color','w','Position',[80 80 1150 780]);
ax=subplot(1,2,1,'Parent',fig); hold(ax,'on'); axis(ax,'equal'); grid(ax,'on');
axis(ax,[-maxR-15 maxR+25 -maxR-12 guide+model.h+25]);
xlabel(ax,'x (mm)'); ylabel(ax,'y (mm)');
cam=patch(ax,G.x,G.y,[.77 .87 .94],'EdgeColor',[.1 .25 .4],'LineWidth',1.5);
plot(ax,0,0,'ko','MarkerFaceColor','k');
text(ax,3,-6,'J1');
plot(ax,[-8 -8 8 8],[guide guide+10 guide+10 guide],'Color',[.4 .4 .4],'LineWidth',2);
plot(ax,[8 maxR+18 maxR+18],[guide+5 guide+5 -maxR-5],'Color',[.5 .5 .5],'LineWidth',2);
plot(ax,[-maxR maxR+22],[-maxR-5 -maxR-5],'k-','LineWidth',2);
text(ax,10,guide+10,'J2');
circle=linspace(0,2*pi,101); y0=model.rb+model.rr;
roller=plot(ax,model.rr*cos(circle),y0+model.rr*sin(circle),'Color',[.85 .3 .1],'LineWidth',2);
pin=plot(ax,0,y0,'ko','MarkerFaceColor','k');
stem=plot(ax,[0 0],[y0 guide+18],'k-','LineWidth',3);
uistack(stem,'bottom');
contact=plot(ax,0,model.rb,'ro','MarkerFaceColor','r');
% Keep the mechanism and all three physical kinematic plots in one figure.
Y=model.motion(th); values=[Y(1,:);omega*Y(2,:);omega^2*Y(3,:)];
yLabels={'Lift (mm)','Velocity (mm/s)','Acceleration (mm/s^2)'};
plotTitles={'Follower displacement','Follower velocity','Follower acceleration'};
dots=gobjects(3,1);
for k=1:3
    kinAx=subplot(3,2,2*k,'Parent',fig); hold(kinAx,'on'); grid(kinAx,'on');
    plot(kinAx,th*180/pi,values(k,:),'Color',[.1 .4 .6],'LineWidth',1.5);
    dots(k)=plot(kinAx,0,values(k,1),'ro','MarkerFaceColor','r');
    xlabel(kinAx,'Cam angle (deg)'); ylabel(kinAx,yLabels{k});
    xlim(kinAx,[0 360]); title(kinAx,plotTitles{k});
    % Reserve room for playback controls below the bottom axes.
    pos=get(kinAx,'Position');pos(2)=pos(2)+.04;pos(4)=pos(4)-.025;
    set(kinAx,'Position',pos);
end
title(ax,sprintf('%s | Rb = %.1f mm',label,model.rb)); drawnow;
print(fig,fullfile(outDir,'Render.png'),'-dpng','-r150');
if ~animate
    install_cam_controls(fig,@updateFrame,omega,0,~deferPlayback);
    return
end
writer=VideoWriter(fullfile(outDir,'Mechanism.avi'),'Motion JPEG AVI');
writer.FrameRate=30; open(writer);
try
    frames=ceil(3*60/rpm*writer.FrameRate);
    for frame=0:frames-1
        if ~ishandle(fig), error('cam:ClosedFigure','Animation window closed before completion.'); end
        angle=omega*frame/writer.FrameRate; a=mod(angle,2*pi);
        updateFrame(a);
        drawnow; writeVideo(writer,getframe(fig)); pause(1/writer.FrameRate);
    end
    close(writer);
catch ME
    close(writer); rethrow(ME);
end
install_cam_controls(fig,@updateFrame,omega,a,~deferPlayback);

    function updateFrame(a)
        c=cos(a); s=sin(a); lift=model.motion(a); center=y0+lift(1);
        set(cam,'XData',c*G.x+s*G.y,'YData',-s*G.x+c*G.y);
        set(roller,'YData',center+model.rr*sin(circle));
        set(pin,'YData',center);set(stem,'YData',[center guide+18+lift(1)]);
        local=model.geometry(a);
        set(contact,'XData',c*local.x+s*local.y,'YData',-s*local.x+c*local.y);
        current=[lift(1);omega*lift(2);omega^2*lift(3)];
        for k=1:3, set(dots(k),'XData',a*180/pi,'YData',current(k)); end
        title(ax,{label,sprintf('Rb %.1f mm | angle %.1f deg | lift %.2f mm',model.rb,a*180/pi,lift(1))});
    end
end

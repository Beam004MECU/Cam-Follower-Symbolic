function model = cam_model(h, rb, rr, schedule)
% Symbolic cycloidal cam; schedule columns: start deg, end deg, start mm, end mm.
if nargin<4, schedule=[0 90 0 h;90 180 h h;180 270 h 0;270 360 0 0]; end
assert(schedule(1,1)==0 && schedule(end,2)==360);
assert(all(schedule(:,2)>schedule(:,1)));
assert(all(abs(schedule(2:end,1)-schedule(1:end-1,2))<1e-10));
assert(all(abs(schedule(2:end,3)-schedule(1:end-1,4))<1e-10));
assert(schedule(1,3)==schedule(end,4));
assert(min(min(schedule(:,3:4)))>=0 && max(max(schedule(:,3:4)))==h);
assert(all(isfinite([h rb rr])) && all([h rb rr]>0),'Dimensions must be positive.');
assert(license('test','Symbolic_Toolbox'),'Symbolic Math Toolbox is required.');
syms u C real
p = sym(pi); beta = p/2;
% Sinusoidal acceleration integrated with zero initial velocity/displacement.
V = int(C*sin(2*p*u),u,0,u);
S = int(V,u,0,u);
c = solve(subs(S,u,1)==1,C);
F = simplify(subs(S,C,c));
D = [F; diff(F,u); diff(F,u,2); diff(F,u,3)];
assert(isAlways(subs(F,u,0)==0) && isAlways(subs(F,u,1)==1));
for order=1:2
    assert(isAlways(subs(D(order+1),u,0)==0));
    assert(isAlways(subs(D(order+1),u,1)==0));
end
assert(isAlways(simplify(subs(F,u,1-u)+F-1)==0));
fun=cell(4,1);
for k=1:4, fun{k}=matlabFunction(D(k),'Vars',u); end
model.h=h; model.rb=rb; model.rr=rr; model.beta=double(beta);
model.schedule=schedule; model.F=F; model.D=D; model.u=u;
model.motion=@(theta)motion(theta,schedule,fun);
model.geometry=@(theta)geometry(theta,rb,rr,schedule,fun);
end

function Y=motion(theta,schedule,fun)
% Rows: s, ds/dtheta, d2s/dtheta2, d3s/dtheta3. Joins use right limits.
th=mod(theta(:)',2*pi); Y=zeros(4,numel(th));
edges=[schedule(:,1);schedule(end,2)]*pi/180;
covered=false(size(th));
for k=1:size(schedule,1)
    start=edges(k); stop=edges(k+1); beta=stop-start;
    delta=schedule(k,4)-schedule(k,3);
    idx=th>=start & th<stop; covered=covered | idx;
    u=(th(idx)-start)/beta;
    Y(1,idx)=schedule(k,3);
    if delta~=0
        for d=0:3
            Y(d+1,idx)=Y(d+1,idx)+delta/beta^d*fun{d+1}(u);
        end
    end
end
assert(all(covered),'A cam angle was not assigned to a motion stage.');
end

function G=geometry(theta,rb,rr,schedule,fun)
theta=theta(:)'; Y=motion(theta,schedule,fun);
r=rb+rr+Y(1,:); ds=Y(2,:); d2s=Y(3,:);
x=-r.*sin(theta); y=r.*cos(theta);
dx=-ds.*sin(theta)-r.*cos(theta); dy=ds.*cos(theta)-r.*sin(theta);
q=hypot(dx,dy);
G.x=x-rr*dy./q; G.y=y+rr*dx./q; % offset pitch curve inward
G.pitchX=x; G.pitchY=y;
G.phi=atan2d(ds,r);
G.kappa=(r.^2+2*ds.^2-r.*d2s)./(r.^2+ds.^2).^(3/2);
G.regularity=1-rr*G.kappa;
end

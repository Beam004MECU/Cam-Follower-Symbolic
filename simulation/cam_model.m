function model = cam_model(h, rb, rr)
% Symbolic cycloidal cam, mm and rad; clockwise input; four 90-degree events.
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
model.F=F; model.D=D; model.u=u;
model.motion=@(theta)motion(theta,h,double(beta),fun);
model.geometry=@(theta)geometry(theta,h,rb,rr,double(beta),fun);
end

function Y=motion(theta,h,beta,fun)
% Rows: s, ds/dtheta, d2s/dtheta2, d3s/dtheta3. Joins use right limits.
th=mod(theta(:)',2*pi); Y=zeros(4,numel(th));
for event=1:2
    start=(event-1)*pi; direction=3-2*event;
    idx=th>=start & th<start+beta; u=(th(idx)-start)/beta;
    for d=0:3, Y(d+1,idx)=direction*h/beta^d*fun{d+1}(u); end
    if event==2, Y(1,idx)=h+Y(1,idx); end
end
Y(1,th>=beta & th<pi)=h;
end

function G=geometry(theta,h,rb,rr,beta,fun)
theta=theta(:)'; Y=motion(theta,h,beta,fun);
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

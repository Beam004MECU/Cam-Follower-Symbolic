function lift=recover_lift(x,y,rr,rb,angles)
% Recover follower lift ONLY from a closed polygonal cam surface.
% At fixed x_center=0, nonpenetration requires center_y >=
% max_surface(y + sqrt(rr^2-x^2)), over |x|<=rr.
% Maximize on every straight edge, including its endpoints. This catches
% remote interference as well as local contact; no motion law is used here.
x=x(:); y=y(:);
assert(numel(x)==numel(y) && numel(x)>=3);
assert(all(isfinite([x;y])) && rr>0 && rb>0);
x=[x;x(1)]; y=[y;y(1)]; lift=zeros(size(angles));
for k=1:numel(angles)
    a=angles(k); X=cos(a)*x+sin(a)*y; Y=-sin(a)*x+cos(a)*y;
    dx=diff(X); dy=diff(Y);
    vertical=abs(dx)<1e-12;
    valid=~vertical & min(X(1:end-1),X(2:end))<=rr & ...
        max(X(1:end-1),X(2:end))>=-rr;
    lo=max(-rr,min(X(1:end-1),X(2:end)));
    hi=min(rr,max(X(1:end-1),X(2:end)));
    m=dy(valid)./dx(valid);
    z=max(lo(valid),min(hi(valid),rr*m./hypot(1,m)));
    height=Y(find(valid))+m.*(z-X(find(valid)))+sqrt(max(0,rr^2-z.^2));
    v=vertical & abs(X(1:end-1))<=rr;
    height=[height; max(Y(find(v)),Y(find(v)+1))+ ...
        sqrt(max(0,rr^2-X(find(v)).^2))];
    assert(~isempty(height),'Cam does not reach the follower axis.');
    lift(k)=max(height)-rb-rr;
end
end

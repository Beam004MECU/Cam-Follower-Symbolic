"""Independent NumPy/SciPy verification, not a MATLAB execution result."""
from pathlib import Path
import json
import numpy as np
from scipy.optimize import minimize_scalar
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
root=Path(__file__).resolve().parents[1]
beta=np.pi/2; rr=5

def motion(t,h,schedule=None):
    if schedule is None:schedule=[(0,90,0,h),(90,180,h,h),(180,270,h,0),(270,360,0,0)]
    t=np.mod(np.asarray(t),2*np.pi).reshape(-1);Y=np.zeros((4,t.size))
    for a,b,s0,s1 in schedule:
        start=np.deg2rad(a);stop=np.deg2rad(b);beta=stop-start;delta=s1-s0
        mask=(t>=start)&(t<stop);u=(t[mask]-start)/beta
        Y[0,mask]=s0
        if delta:
            Y[:,mask]+=np.array([u-np.sin(2*np.pi*u)/(2*np.pi),1-np.cos(2*np.pi*u),2*np.pi*np.sin(2*np.pi*u),4*np.pi**2*np.cos(2*np.pi*u)])*np.array([delta/beta**d for d in range(4)])[:,None]
    return Y

def geom(t,h,rb,schedule=None):
    t=np.asarray(t).reshape(-1);Y=motion(t,h,schedule);r=rb+rr+Y[0];ds=Y[1];d2s=Y[2]
    x=-r*np.sin(t);y=r*np.cos(t);dx=-ds*np.sin(t)-r*np.cos(t);dy=ds*np.cos(t)-r*np.sin(t);q=np.hypot(dx,dy)
    return x-rr*dy/q,y+rr*dx/q,np.rad2deg(np.arctan2(ds,r)),(r*r+2*ds*ds-r*d2s)/(r*r+ds*ds)**1.5

def verify(h,rb,schedule=None):
    t=np.linspace(0,2*np.pi,14401);x,y,phi,k=geom(t,h,rb,schedule)
    assert np.max(np.abs(phi))<30+1e-7
    assert 1/np.max(k)>=7 and np.min(1-rr*k)>0
    mingap=1e9;contact_error=0
    for a in np.linspace(0,2*np.pi,361):
        center=rb+rr+motion([a],h,schedule)[0,0]
        mingap=min(mingap,np.min(np.hypot(x+center*np.sin(a),y-center*np.cos(a)))-rr)
        xx,yy,_,_=geom([a],h,rb,schedule)
        X=np.cos(a)*xx+np.sin(a)*yy;Y=-np.sin(a)*xx+np.cos(a)*yy
        contact_error=max(contact_error,float(abs(np.hypot(X,Y-center)[0]-rr)))
    assert mingap>=-1e-6 and contact_error<1e-10
    t=np.array([.3,.8,1.2,3.4,3.9,4.4]);dt=1e-5
    residual=np.max(np.abs((motion(t+dt,h,schedule)[:2]-motion(t-dt,h,schedule)[:2])/(2*dt)-motion(t,h,schedule)[1:3]),axis=1)
    assert np.max(residual)<1e-6
    return dict(h=h,rb=rb,max_pressure_deg=float(max(abs(phi))),min_pitch_radius=float(1/max(k)),min_gap=float(mingap),max_contact_error=contact_error,derivative_residuals=residual.tolist())

if __name__=='__main__':
    schedule=[(0,60,0,10),(60,100,10,10),(100,180,10,25),(180,220,25,25),(220,320,25,0),(320,360,0,0)]
    bounds=[];roots=[]
    for a,b,s0,s1 in schedule:
        delta=s1-s0
        if not delta:continue
        beta=np.deg2rad(b-a);u=np.arctan2(2*np.pi,np.sign(delta)*beta*np.tan(np.pi/6))/np.pi
        B=lambda z:abs(delta)*(1-np.cos(2*np.pi*z))/(beta*np.tan(np.pi/6))-rr-s0-delta*(z-np.sin(2*np.pi*z)/(2*np.pi))
        bound=max(B(0),B(u),B(1));opt=minimize_scalar(lambda z:-B(z),bounds=(0,1),method='bounded',options={'xatol':1e-13})
        assert abs(bound+opt.fun)<1e-8
        bounds.append(bound);roots.append(u)
    bound=max(bounds);rb=np.ceil(bound*2)/2
    results={'status':'Independent Python reference; stepped MATLAB revision not yet run','main':verify(20,40),'bonus_continuous':verify(25,bound,schedule),'bonus':verify(25,rb,schedule),'critical_u':roots,'stage_bounds':bounds}
    for deg,value in [(a,s0) for a,b,s0,s1 in schedule]:
        angle=np.deg2rad(deg)
        for q in [np.nextafter(angle,-np.inf),angle,np.nextafter(angle,np.inf)]:
            assert abs(motion([q],25,schedule)[0,0]-value)<1e-10
    for deg,value in [(80,10),(200,25),(340,0)]:
        Y=motion([np.deg2rad(deg)],25,schedule);assert abs(Y[0,0]-value)<1e-12 and np.max(abs(Y[1:3]))<1e-12
    (root/'experiments/reference_results.json').write_text(json.dumps(results,indent=2))
    print(json.dumps(results,indent=2))
    t=np.linspace(0,2*np.pi,1801);x,y,_,_=geom(t,25,rb,schedule)
    fig,axes=plt.subplots(1,2,figsize=(10,4.7));axes[0].fill(x,y,color='#d8e7f1',ec='#274c77');axes[0].set_aspect('equal');axes[0].set_title(f'Synthesized cam: Rb = {rb:g} mm');axes[0].set_xlabel('x (mm)');axes[0].set_ylabel('y (mm)')
    axes[1].plot(np.rad2deg(t),motion(t,25,schedule)[0],color='#274c77',lw=2);axes[1].set(xlim=(0,360),ylim=(-1,27),xlabel='Cam angle (deg)',ylabel='Follower lift (mm)',title='Stepped lift: 0 -> 10 -> 25 -> 0 mm');axes[1].set_yticks([0,10,25])
    for ax in axes:ax.grid(alpha=.2)
    fig.tight_layout();fig.savefig(root/'media/stepped_synthesis.png',dpi=160)

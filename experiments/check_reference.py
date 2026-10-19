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

def motion(t,h):
    t=np.mod(np.asarray(t),2*np.pi); Y=np.zeros((4,t.size))
    t=t.reshape(-1)
    for start,sign in [(0,1),(np.pi,-1)]:
        mask=(t>=start)&(t<start+beta);u=(t[mask]-start)/beta
        Y[:,mask]=np.array([u-np.sin(2*np.pi*u)/(2*np.pi),1-np.cos(2*np.pi*u),2*np.pi*np.sin(2*np.pi*u),4*np.pi**2*np.cos(2*np.pi*u)])*np.array([sign*h/beta**d for d in range(4)])[:,None]
        if sign<0:Y[0,mask]+=h
    Y[0,(t>=beta)&(t<np.pi)]=h
    return Y

def geom(t,h,rb):
    t=np.asarray(t).reshape(-1);Y=motion(t,h);r=rb+rr+Y[0];ds=Y[1];d2s=Y[2]
    x=-r*np.sin(t);y=r*np.cos(t);dx=-ds*np.sin(t)-r*np.cos(t);dy=ds*np.cos(t)-r*np.sin(t);q=np.hypot(dx,dy)
    return x-rr*dy/q,y+rr*dx/q,np.rad2deg(np.arctan2(ds,r)),(r*r+2*ds*ds-r*d2s)/(r*r+ds*ds)**1.5

def verify(h,rb):
    t=np.linspace(0,2*np.pi,14401);x,y,phi,k=geom(t,h,rb)
    assert np.max(np.abs(phi))<30+1e-7
    assert 1/np.max(k)>=7 and np.min(1-rr*k)>0
    mingap=1e9;contact_error=0
    for a in np.linspace(0,2*np.pi,361):
        center=rb+rr+motion([a],h)[0,0]
        mingap=min(mingap,np.min(np.hypot(x+center*np.sin(a),y-center*np.cos(a)))-rr)
        xx,yy,_,_=geom([a],h,rb)
        X=np.cos(a)*xx+np.sin(a)*yy;Y=-np.sin(a)*xx+np.cos(a)*yy
        contact_error=max(contact_error,float(abs(np.hypot(X,Y-center)[0]-rr)))
    assert mingap>=-1e-6 and contact_error<1e-10
    t=np.array([.3,.8,1.2,3.4,3.9,4.4]);dt=1e-5
    residual=np.max(np.abs((motion(t+dt,h)[:2]-motion(t-dt,h)[:2])/(2*dt)-motion(t,h)[1:3]),axis=1)
    assert np.max(residual)<1e-6
    return dict(h=h,rb=rb,max_pressure_deg=float(max(abs(phi))),min_pitch_radius=float(1/max(k)),min_gap=float(mingap),max_contact_error=contact_error,derivative_residuals=residual.tolist())

if __name__=='__main__':
    h=30;us=np.arctan(2*np.pi/(beta*np.tan(np.pi/6)))/np.pi
    B=lambda u:h*(1-np.cos(2*np.pi*u))/(beta*np.tan(np.pi/6))-rr-h*(u-np.sin(2*np.pi*u)/(2*np.pi))
    bound=max(B(0),B(us),B(1));opt=minimize_scalar(lambda u:-B(u),bounds=(0,1),method='bounded',options={'xatol':1e-13})
    assert abs(bound+opt.fun)<1e-8
    results={'status':'Independent Python reference; MATLAB not yet run','main':verify(20,40),'bonus_continuous':verify(30,bound),'bonus':verify(30,np.ceil(bound*2)/2),'critical_u':us}
    (root/'experiments/reference_results.json').write_text(json.dumps(results,indent=2))
    print(json.dumps(results,indent=2))
    # Geometry diagram at a mid-rise angle; frame is outside the cam envelope.
    h=20;rb=40;a=np.pi/4;t=np.linspace(0,2*np.pi,1801);x,y,_,_=geom(t,h,rb)
    X=np.cos(a)*x+np.sin(a)*y;Y=-np.sin(a)*x+np.cos(a)*y;center=rb+rr+motion([a],h)[0,0]
    fig,ax=plt.subplots(figsize=(8,8));ax.fill(X,Y,color='#d8e7f1',ec='#274c77',lw=2)
    ax.plot([0,0],[center,106],color='#303030',lw=3)
    ax.add_patch(plt.Circle((0,center),rr,fc='white',ec='#c36b3e',lw=2,zorder=5));ax.plot(0,center,'ko',zorder=6)
    ax.plot(0,0,'ko');ax.plot([-67,80],[-68,-68],'k-',lw=3);ax.plot([78,78,8],[-68,90,90],color='gray',lw=3)
    for z in [84,96]:ax.plot([-8,8],[z,z],color='gray',lw=3)
    ax.annotate('1: Ground / frame',xy=(78,15),xytext=(22,-59),arrowprops={'arrowstyle':'->'})
    ax.text(-42,-30,'2: Cam',fontsize=12)
    ax.annotate('3: Follower',xy=(0,103),xytext=(-65,111),arrowprops={'arrowstyle':'->'})
    ax.annotate('4: Roller',xy=(-4,center+2),xytext=(-65,70),arrowprops={'arrowstyle':'->'})
    ax.annotate('J1: Revolute',xy=(0,0),xytext=(-65,-52),arrowprops={'arrowstyle':'->'})
    ax.annotate('J2: Prismatic',xy=(4,90),xytext=(18,111),arrowprops={'arrowstyle':'->'})
    ax.annotate('J3: Revolute',xy=(0,center),xytext=(20,67),arrowprops={'arrowstyle':'->'})
    xx,yy,_,_=geom([a],h,rb);cx=np.cos(a)*xx[0]+np.sin(a)*yy[0];cy=-np.sin(a)*xx[0]+np.cos(a)*yy[0]
    ax.plot(cx,cy,'ro',zorder=7);ax.annotate('J4: Higher pair',xy=(cx,cy),xytext=(24,42),arrowprops={'arrowstyle':'->'})
    ax.annotate('',xy=(13,106),xytext=(13,78),arrowprops={'arrowstyle':'<->','color':'#274c77'});ax.text(15,80,'s')
    ax.set_aspect('equal');ax.set_xlim(-75,90);ax.set_ylim(-78,124);ax.set_xlabel('x (mm)');ax.set_ylabel('y (mm)');ax.grid(alpha=.15)
    ax.set_title('Cam and roller follower: links and joints\nRb = 40 mm, Rr = 5 mm, lift = 20 mm',fontsize=13)
    fig.tight_layout();fig.savefig(root/'media/links_joints.png',dpi=170);plt.close(fig)

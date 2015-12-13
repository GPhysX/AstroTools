clear all
CelestialConstants

% v_L4 = sqrt()
%% Problem 2
r = 6378.1363+1.655064; %km

JD = computeJD(2015,12,8,13-7,31,41);
T_UT1 = ((JD)-2451545)/36525;

GMST = 67310.54841 ...
    + (876600*3600+8640184.812866) * T_UT1 ...
    + 0.093104 * T_UT1 * T_UT1 ...
    - 6.2e-6 * T_UT1 * T_UT1 * T_UT1;
while GMST > 86400
GMST = GMST-86400
end
LST = GMST/240-105

phi_gd = atand(tand(40)/(1-Earth.oblate_ecc^2));
r_ecf = Euler2DCM('23', [-(90-phi_gd), -LST]*pi/180)*[0;0;r]
v = r_ecf/r*0.002+cross([0;0;Earth.spin_rate],r_ecf)
% v = cross([0;0;Earth.spin_rate],r_ecf)

[a,e,i,w,RAAN,f] = cart2OE(r_ecf,v,Earth.mu)
ra = a*(1+e)
rp = a*(1-e)
h_max = ra-r

%% Problem 3
clear
CelestialConstants
a = 3*149597870.7;
m_ast = 1e15;
SOI = (m_ast/1.9891e30)^(2/5)*a

G = 6.673e-20;
mu_ast = G*m_ast
P = 2*pi*sqrt(40^3/mu_ast)
P/3600
v_circ = sqrt(mu_ast/40)
a_new = 1/(2/40-(v_circ-.001)^2/mu_ast)
e_xfer = 40/a_new-1
n_xfer = sqrt(mu_ast/a_new^3)
Mf = pi+n_xfer*6*3600
Mf*180/pi
f = E2f(M2E(Mf,e_xfer),e_xfer)
f*180/pi
rf = a_new*(1-e_xfer^2)/(1+e_xfer*cos(f))
fpa = atan2(e_xfer*sin(f),1+e_xfer*cos(f))
fpa*180/pi
v_circ_f = sqrt(mu_ast/rf)
v_xfer_f = sqrt(2*mu_ast/rf-mu_ast/a_new)
dV = [0;v_circ_f]-[sin(fpa);cos(fpa)]*v_xfer_f
norm(dV)


%% Problem 4
clear
CelestialConstants

r_venus = [48965315.1 96179438.8 0.0]'; %km
v_venus = [-31.322263 15.730492 0.0]'; %km

v_approach = [-28.123456 8.654321 0.0]'; %km

SOI = (Venus.m/Sun.m)^(2/5)*norm(r_venus)
energy = norm(v_approach)^2/2-Sun.mu/(norm(r_venus)-SOI)
V_inf_app = v_approach-v_venus
norm(V_inf_app)
energy_venus = norm(V_inf_app)^2/2-Venus.mu/SOI

%ccw 
V_inf_dep_ccw = Euler2DCM('3',[42*pi/180])*V_inf_app
V_dep_ccw = V_inf_dep_ccw+v_venus
energy = norm(V_dep_ccw)^2/2-Sun.mu/(norm(r_venus)-SOI)

%cw 
V_inf_dep_cw = Euler2DCM('3',[-42*pi/180])*V_inf_app
V_dep_cw = V_inf_dep_cw+v_venus
energy = norm(V_dep_cw)^2/2-Sun.mu/(norm(r_venus)-SOI)

rp = Venus.mu/norm(V_inf_app)*(1/cosd((90-42)/2)-1)

%% Problem 5
clear
CelestialConstants
h = 185; %km
v_inf = 7-(sqrt(2*Earth.mu/(h+Earth.R)) - sqrt(Earth.mu/(h+Earth.R)))

v_earth = sqrt(Sun.mu/au2km)

vp = v_inf+v_earth
a_xfer1 = 1/(2/au2km-norm(vp)^2/Sun.mu)
a_xfer1/au2km
ra1 = 2*a_xfer1-au2km
ra1/au2km

%b
va = v_earth-v_inf
a_xfer2 = 1/(2/au2km-norm(va)^2/Sun.mu)
a_xfer2/au2km
ra2 = 2*a_xfer2-au2km
ra2/au2km

%c 
i = asind(v_inf/v_earth)

%% Problem 6
clear
CelestialConstants
rp = 7e3;
ra = 8e3;
i = 100;
P = 6000; %s
R = 6e3;
r_planet = 2*au2km;

a = (rp+ra)/2
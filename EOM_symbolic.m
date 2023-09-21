close all; clear; clc
%Axis
syms psi theta phi 
Lpsi = [cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
Ltheta = [cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)];
Lphi = [1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];
LEB = Lphi*Ltheta*Lpsi; %Earth to Body
LBE = transpose(LEB); %Body to Earth
syms m g
WE = [0; 0; m*g]; %Weight - defined in inertial frame 
WB = LEB*WE; %Weight - body axis
%EOM
syms u v w p q r udot vdot wdot
FB = m*([udot; vdot; wdot] + cross([p; q; r],[u, v, w])); %Fx Fy Fz
syms Ixx Iyy Izz Ixz pdot qdot rdot
I = [Ixx 0 -Ixz; 0 Iyy 0; -Ixz 0 Izz]; %Inertia - body axis
MB = I*[pdot; qdot; rdot] + cross([p, q, r],I*[p; q; r]); %Mx My Mz
%Earth Velocity
VE = LBE*[u; v; w]; %XEdot YEdot ZEdot 
%Angular Velocicy and Euler Angle Derivatives
syms psidot thetadot phidot
OmegaB = psidot*[-sin(theta); cos(theta)*sin(phi); cos(phi)*cos(theta)] + ...
    thetadot*[0; cos(phi); -sin(phi)] + phidot*[1; 0; 0]; %p q r
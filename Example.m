%% Heat And Mass Lab 3
% University of Minnesota Duluth
% Dustin Moriarty

clear all
addpath('latextable')
addpath('Psychro')

patm = 101.1e3; %Pa

% Load State Data
A = mas('t__t_w',21.9,8.9,patm); 
B = mas('t__t_w',29.6,11.3,patm);
C = mas('t__t_w',15.3,5.6,patm);
D = mas('t__t_w',21.2,8.6,patm);

A.description = 'A';
B.description = 'B';
C.description = 'C';
D.description = 'D';

%% Resistance Heat
R_heaters = [47.2 46.6 46.8 47.1] %Ohm
SupplyVoltage = 210 %Volts
P_heaters = SupplyVoltage^2./R_heaters*1e-3 %Heater Power (kW)
z = 7.25 % Oriface Differential Pressure mmH20

d1m_da = 0.0517*sqrt(z/D.v)

d1Q_AB = d1m_da*(B.h-A.h) %Enthalpy To Evap Coils (kW)
d1Q_BC = d1m_da*(C.h-B.h) %Enthalpy To Evap Coils (kW)
d1Q_CD = d1m_da*(D.h-C.h) %Enthalpy To Evap Coils (kW)


latextable([d1Q_AB,d1Q_BC,d1Q_CD],...
    'name','Qout.tex','format','%3.3f','Horiz',...
    {'$\dot{q}_{AB}\,\left(kW\right)$','$\dot{q}_{BC}\,\left(kW\right)$',...
    '$\dot{q}_{CD}\,\left(kW\right)$'})
latextable(P_heaters','Horiz',{'Heater Power $\left(kW\right)$'},...
    'Vert',{'Heater 1','Heater 2','Heater 3','Heater 4'},...
    'name','HeaterOut.tex','format','%3.3f')

%% Make Plots
f= psychrometric(patm*1e-3);
set(f,'PaperPositionMode','auto');
plot(A,B,C,D);
print -djpeg 'out.jpg' -r100
%close(f)

%% Export Table
latex('out.tex',A,B,C,D)


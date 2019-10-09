%%
clear; clc;

%%
%start with basic assumptions 

load Temp_Alt_Fit;
%altitude of mission
altitude = [400:-5:0]*1000; %m

%pressure range
pressure = [.01:.1236:10]*100000; %Pa

%altitude = [400:-25:0]*1000;
%temperature = [105, 95, 85, 80, 75, 80, 90, 100, 120, 150, 160, 180, 200, 220, 250, 275, 300];

%density model
rho = pressure./((8.315.*Temp_Alt_Fit(altitude))');
plot(-altitude, rho)
xlabel('Altitude (m)')
ylabel('Density (kg/m^3)')

%%
%initial conditions for maximum profile

%tension
T = 0;
%gravity
g = 10.4; % m/s2

x_probe=zeros([1 length(altitude)]); %m
v_probe=zeros([1 length(altitude)]); %m/s
a_probe=zeros([1 length(altitude)]); %m/s
Fd_probe=zeros([1 length(altitude)]);
delta_t = 100;

%initial probe conditions
v_probe(1)= 13166.667; %m/s
A_probe= 0.78; %m2
m_probe = 500; %kg
Cd_probe=1.3;


%%
for i=1:length(rho)
if altitude(i) < 200000 && altitude(i) >= 150000
    rho(i) = rho(i) * (17/1000); %molar mass of NH3
    
elseif altitude(i) < 150000 && altitude(i) >= 100000
    rho(i) = rho(i) * (51/1000); %molar mass of nh4sh
    
%this is solid 
elseif altitude(i) < 100000 && altitude(i) >= 0
    rho(i) = rho(i) * (917); %molar mass h20
    
else
    rho(i) = rho(i) * 0;
end
end

plot(-altitude, rho)
xlabel('Altitude (m)')
ylabel('Density (kg/m^3)')


% rho in units of kg/m3

%% 
for q=2:length(altitude)
    
    if pressure(q) > 100000
        A_probe = 50; % m2
    end
    
    %probe iteration
    Fd_probe(q)= 1/2*Cd_probe*rho(q)*v_probe(q-1)^2*A_probe;
    a_probe(q)= (m_probe*g-Fd_probe(q))/m_probe;
    v_probe(q)=v_probe(q-1)+a_probe(q)*delta_t;
    x_probe(q) = x_probe(q-1) + v_probe(q-1)*delta_t + 1/2*a_probe(q)*delta_t^2;

end




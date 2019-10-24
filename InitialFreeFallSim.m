clear; clc;

%use linear density model 

%change iterations for more accuracy 

m=5; % kg
g=9.81; % kg/m2

z=72000000;

%rho=linspace(1.2,10,z)
%rho=1.2; % kg/m^3

Cd=.4; %drag coeff
A=.09; %m^2
d=.3385;
mu = 1.789E-5; %viscosity in Ns/m
%http://www.aerodynamics4students.com/properties-of-the-atmosphere/sea-level-conditions.php


%Time step
v=zeros(1,z); % Speed
F=zeros(1,z); %force of drag
a=zeros(1,z); %total accel
x=zeros(1,z);
rho=zeros(1,z);
%Re= zeros(1,z);

v(1)=27000; %m/s
deltat=.0001;
time=deltat*z;

time_hours = time/60/60;

for i=1:z
    
    rho(i)=(3000/60000000)*x(i);
    %model for rho based off of graphic of density near radius of Saturn 
    %https://oxfordre.com/planetaryscience/view/10.1093/acrefore/9780190647926.001.0001/acrefore-9780190647926-e-175
   
    
    Re(i) = (rho(i)*v(i)*d)/mu;
    %drag force calculations 
    
    
    F(i) = 1/2*rho(i)*A*Cd*v(i)^2;
    %force due to drag 
    
    if v(i) < 0 
        F(i) = -F(i);
    end
    
    %drag vector opposes velocity 
    %ie if velocity is positive, drag vector is negative 
    
    a(i) = (g-F(i)/m); 
    %new accelration 
     
    v(i+1)=v(i)+deltat*a(i);
    %assume constant a
   
    x(i+1) = x(i) + v(i)*deltat + (a(i)*deltat^2)/2;
    %current position
        
end

figure
plot(v)
title('Velocity')
xlabel('Iterations')
ylabel('Velocity (m/s)')

figure
plot(x)
title('Position')
xlabel('Iterations')
ylabel('Position (m)')

%%
figure
plot(F)
title('Drag')

figure
plot(a)
title('Acceleration')

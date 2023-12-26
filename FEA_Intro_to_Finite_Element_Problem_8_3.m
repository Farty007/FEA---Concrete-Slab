%% FEA analysis of Concrete structure - Introduction to Finite Elements in Engineering - Second Edition - Problem 8.3

clc
clear all

smodel = createpde('structural','static-solid');
importGeometry(smodel, 'Concrete Slab_Fine.STL');
pdegplot(smodel, 'FaceLabels','on', 'FaceAlpha', 0.5);

msh = generateMesh(smodel, 'Hmax', 20);
pdeplot3D(smodel)

E = 31026407819; % Young's Modulus, in Pa
nu = 0.15; % Poisson's Ration
gVal = [0;0;-9.81]; % m/s^2
rho = 145; % lbs - weight per cubic foot
rhoc = (rho)*16.02; % kg/m^3

structuralProperties(smodel,'YoungsModulus',E,'PoissonsRatio',nu,'MassDensity',rhoc);
structuralBC(smodel, 'Face', 18, 'Constraint', 'fixed');
structuralBC(smodel, 'Face', 3, 'Constraint', 'fixed');
structuralBC(smodel, 'Edge', 17, 'Constraint', 'fixed');
structuralBC(smodel, 'Edge', 18, 'Constraint', 'fixed');
structuralBC(smodel, 'Edge', 19, 'Constraint', 'fixed');
structuralBC(smodel, 'Edge', 20, 'Constraint', 'fixed');
structuralBC(smodel, 'Edge', 49, 'Constraint', 'fixed');
structuralBC(smodel, 'Edge', 50, 'Constraint', 'fixed');
structuralBC(smodel, 'Edge', 51, 'Constraint', 'fixed');
structuralBC(smodel, 'Edge', 52, 'Constraint', 'fixed');
structuralBodyLoad(smodel,'GravitationalAcceleration', gVal);

answer = solve(smodel);
pdeplot3D(smodel, 'ColorMapData', answer.VonMisesStress,'Deformation',answer.Displacement);

zVal = (answer.Displacement.z)/1000;
s =  size(zVal);
o = 1;
iterator = 1;
zVal_mean = zeros(round(s(1)/1000));
for i = 1:1000:s(1)
    zVal_mean(iterator) = mean(zVal(o:i));
    o = i+1;
    iterator = iterator + 1;
end
dist = linspace(0,27,round(s(1)/1000));
figure(2)
plot(dist,zVal_mean)
xlabel('Distance from the left end of the beam - in feets')
ylabel('Displacement from neutral line - in meters')
xlim([0 27])
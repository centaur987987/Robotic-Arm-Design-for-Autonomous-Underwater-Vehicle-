% Andrew Centa
% Find manipulability equations
clc
clear
close all

% Code operates like a computational notebook.

% postional equation are pulled from Jacobian_Analysis.m Forward Kinematics

% Section 1: Forward Kinematics
% Section 2: Jacobian
% Section 3: Positional Jacobian and Manipulability
% Section 4: Manipulability Plot

%% Section 1: Forward Kinematics 

syms th1 th2 th3 th4 th6 a3 a4 a5 d5 real % Set Variables

% Enter transformation matrices from Appendix 9.1.2
T12 = [cos(th1), 0, -sin(th1), 0; sin(th1), 0, cos(th1), 0; 0, -1, 0, 0; 0, 0, 0, 1];

T23 = [cos(th2), -sin(th2), 0, a3*cos(th2); sin(th2), cos(th2), 0, a3*sin(th2); 0, 0, 1, 0; 0, 0, 0, 1];

T34 = [cos(th3), -sin(th3), 0, a4*cos(th3); sin(th3), cos(th3), 0, a4*sin(th3); 0, 0, 1, 0; 0, 0, 0, 1];

T45 = [cos(th4), 0, -sin(th4), a5*cos(th4); sin(th4), 0, cos(th4), a5*sin(th4); 0, -1, 0, 0; 0, 0, 0, 1];

T56 = [1, 0, 0, 0; 0, 0, -1, 0; 0, 1, 0, d5; 0, 0, 0, 1];

T67 = [cos(th6), -sin(th6), 0, 0; sin(th6), cos(th6), 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

% Eaquation (6)
T17 = simplify(T12 * T23 * T34 * T45 * T56 * T67)

pretty(T17)

%% Section 2: Jacobian
% Cumulative transformations
T02 = T12 * T23;
T03 = T02 * T34;
T04 = T03 * T45;
T05 = T04 * T56;
T17 = simplify(T05 * T67);

% Define the 6 joint variables vector
q = [th1, th2, th3, th4, d5, th6];

% Compute Linear Velocity Jacobian (Jv)
% The partial derivatives automatically scale correctly for the prismatic joint
p06 = T17(1:3, 4); %  positional components from forward kinematics
Jv = jacobian(p06, q);

% Compute Angular Velocity Jacobian (Jw)
% Extract z-axes from the transformation matrices
z0 = [0; 0; 1];           % Base frame z-axis (Joint 1)
z1 = T12(1:3, 3);         % Joint 2 axis
z2 = T02(1:3, 3);         % Joint 3 axis
z3 = T03(1:3, 3);         % Joint 4 axis
z4 = [0; 0; 0];           % Joint 5 is prismatic -> no angular velocity contribution
z5 = T05(1:3, 3);         % Joint 6 axis

Jw = [z0, z1, z2, z3, z4, z5];

% Construct and simplify the full 6x6 Jacobian
J = [Jv; Jw];
J = simplify(J)
pretty(J)

%% Section 3: positional jacobian and Manipulability
p = T17(1:3, 4); %  positional components from forward kinematics
p = simplify(p);

q = [th1 th2 th3 th4 d5 th6];

Jp = simplify(jacobian(p,q))
pretty(Jp')
% Manipulability (Yoshikawa measure)
gramian = Jp * Jp';              % 3x3 symmetric positive semi-definite matrix
%pretty(gramian)
m = simplify(det(gramian))



%% Section 4: Manipulability Plot
a3_val = 100; a4_val = 450; a5_val = 510; d5_val = 0; % inputs

m_num = subs(m, [a3, a4, a5, d5], [a3_val, a4_val, a5_val, d5_val]);
m_num = subs(m_num, th1, 0);   % fix th1 = 0

% Convert to fast numeric function of (th2, th3, th4)
m_func = matlabFunction(m_num, 'Vars', [th2, th3, th4]);

% Plot Manipulability Slices 

% limits
th2_vals = linspace(-180, 180, 150);
th3_vals = linspace(-180, 180, 150);
[TH2_deg, TH3_deg] = meshgrid(th2_vals, th3_vals);
TH2 = deg2rad(TH2_deg);
TH3 = deg2rad(TH3_deg);

%option to include theta 4
th4_slices = [-180, -90, -45, 0, 90, 135];

% plot settings
figure('Color', 'k', 'Position', [100, 100, 1400, 800]);

% actually plotted material
W_raw  = m_func(TH2, TH3, deg2rad(0));
W      = sqrt(abs(real(W_raw)));
W_norm = W / max(W(:));

% Plot settings
ax = axes;
contourf(TH2_deg, TH3_deg, W_norm, 40, 'LineColor', 'none');
colormap(ax, parula);
clim([0 1]);
hold on;
contour(TH2_deg, TH3_deg, W_norm, 20, 'Color', 'w', 'LineWidth', 0.4);
contour(TH2_deg, TH3_deg, W_norm, [0.01 0.01], 'r', 'LineWidth', 2);

set(ax, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', ...
    'FontSize', 10, 'FontWeight', 'bold', ...
    'XGrid', 'on', 'YGrid', 'on', ...
    'GridColor', 'w', 'GridAlpha', 0.15, ...
    'Box', 'on', 'LineWidth', 1);

xlabel('\theta_2 (degrees)', 'Color', 'w', 'FontSize', 12);
ylabel('\theta_3 (degrees)', 'Color', 'w', 'FontSize', 12);
title('Manipulability Measure (Singularities in Red)', ...
    'Color', 'w', 'FontSize', 13, 'FontWeight', 'bold');

xlim([-180 180]); ylim([-180 180]);
xticks(-180:60:180); yticks(-180:60:180);

cb = colorbar;
cb.Color = 'w';
cb.FontSize = 10;
ylabel(cb, 'Normalized Manipulability', 'Color', 'w', 'FontSize', 11);
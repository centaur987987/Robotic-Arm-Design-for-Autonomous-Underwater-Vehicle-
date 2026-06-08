% Name: Andrew Centa
% Objective: Plot the reachable workspaces for each position given 

% Code operates like a computational notebook.

% postional equation are pulled from Jacobian_Analysis.m Forward Kinematics

% Section 1: Length inputs
% Section 2: Reachable workspace code for Collection Position
% Section 3: Rechable workspace code for loading position
% Section 4: Code to draw full linkage. Defaults to stowed position
% Section 5: function for plotting Reachable Workspace referenced

%% Section 1: Lengths
% Length Variables
L3=100;
L4=450;
L5=510;
L6=380;

%% Section 2: Reachable Workspace Code for Collection Position
close all

% Angle range variables
theta_1=[30:10:330];
theta_2=-90;  
theta_3=[-90:10:-8]; 
theta_4 = [-90: 10: -8];

% Prismatic range
d5=[1:5:L6];

% 3D Plot
Plot3DReachableWorkspace(L3, L4, L5, theta_1, theta_2, theta_3, theta_4, d5)

%% Section 3: Reachable Workspace Code for storing position
close all

% Angle range variables
theta_1=[180];
theta_2=-90;  
theta_3 = [30 :2: 80]; 
theta_4 = [8: 2: 100]; 

% Prismatic range
d5=[0:2:50];

% 3D plot
Plot3DReachableWorkspace(L3, L4, L5, theta_1, theta_2, theta_3, theta_4, d5)

%% Section 3.5: Reachable Workspace Code for storing position (front side)
close all

% Angle range variables
theta_1=[180];
theta_2= 0;  
theta_3 = [-120 :2: -8]; 
theta_4 = [-160: 2: -8]; 

% Prismatic range
d5=[0:2:50];

% 3D plot
Plot3DReachableWorkspace(L3, L4, L5, theta_1, theta_2, theta_3, theta_4, d5)

%% Section 4: Draw 6 linkage
close all
clear
% Link Lengths
a3 = 100;     % Length of Link 3 
a4 = 450;     % Length of Link 4
a5 = 510;     % Length of Link 5
% ACTUAL STORED INPUTS FOR PRINTING

t1 = 180;     % Base 3D rotation
t2 = 0;       % link 1 angle
t3 = -8.96;   % link 2 angle
t4 = -171.24; % link 3 angle
d  = 0;       % Stowed prismatic extension distance (d5)

% Cumulative Compound Angles for Coordinate Frame Math 
% From Jacobian_Analysis Forward Kinematics
t23 = t2 + t3;
t234 = t2 + t3 + t4;

%   3D JOINT POSITION CALCULATIONS
X0 = 0; Y0 = 0; Z0 = 0;

% Link 1
X1 = cosd(t1) * (a3 * cosd(t2));
Y1 = sind(t1) * (a3 * cosd(t2));
Z1 = -(a3 * sind(t2));

% Link 2
X2 = X1 + cosd(t1) * (a4 * cosd(t23));
Y2 = Y1 + sind(t1) * (a4 * cosd(t23));
Z2 = Z1 - (a4 * sind(t23));

% Link 3
X3 = X2 + cosd(t1) * (a5 * cosd(t234));
Y3 = Y2 + sind(t1) * (a5 * cosd(t234));
Z3 = Z2 - (a5 * sind(t234));

% End-Effector Calculation
Px_factor = a3*cosd(t2) + a4*cosd(t23) + a5*cosd(t234) - d*sind(t234);

X4 = cosd(t1) * Px_factor;
Y4 = sind(t1) * Px_factor;
Z4 = -a3*sind(t2) - a4*sind(t23) - a5*sind(t234) - d*cosd(t234);


% Plotting
figure('Color', [1 1 1]);
hold on;

% Vectors for the Plot
all_X = [X0, X1, X2, X3, X4];
all_Y = [Y0, Y1, Y2, Y3, Y4];
all_Z = [Z0, Z1, Z2, Z3, Z4];

% End effector tip blue
scatter3(X4, Y4, Z4, 60, [0.2, 0.4, 0.6], 'filled');

% Origin green
plot3(0, 0, 0, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
% Draw links as lines
plot3([X0, X1], [Y0, Y1], [Z0, Z1], 'k-', 'LineWidth', 3);  % Link 3
plot3([X1, X2], [Y1, Y2], [Z1, Z2], 'b-', 'LineWidth', 3);  % Link 4
plot3([X2, X3], [Y2, Y3], [Z2, Z3], 'r-', 'LineWidth', 3);  % Link 5
plot3([X3, X4], [Y3, Y4], [Z3, Z4], 'g-', 'LineWidth', 3);  % End effector

% Joint markers
scatter3(X1, Y1, Z1, 60, 'k', 'filled');
scatter3(X2, Y2, Z2, 60, 'k', 'filled');
scatter3(X3, Y3, Z3, 60, 'k', 'filled');

% AUV body
vertices = [
     200,  -100, -100;
     200,   100, -100;
     200,   100,  100;
     200,  -100,  100;
    -800,  -100, -100;
    -800,   100, -100;
    -800,   100,  100;
    -800,  -100,  100
];
faces = [
    1, 2, 3, 4;  5, 6, 7, 8;  1, 2, 6, 5;
    2, 3, 7, 6;  3, 4, 8, 7;  4, 1, 5, 8
];
patch('Vertices', vertices, 'Faces', faces, ...
    'FaceColor', [0.5, 0.5, 0.5], ...
    'FaceAlpha', 0.4, ...
    'EdgeColor', 'k', ...
    'LineWidth', 1.5);

% Dynamic Padding
pad = 150;
xlim([min(all_X) - pad, max(all_X) + pad]);
ylim([min(all_Y) - pad, max(all_Y) + pad]);
zlim([min(all_Z) - pad, max(all_Z) + pad]);

grid on;
axis equal;
view(45, 30);

% Axis font and color
ax = gca;
ax.FontSize = 14;
ax.FontWeight = 'bold';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.ZColor = [0 0 0];
ax.GridColor = [0 0 0];
ax.GridAlpha = 0.3;
ax.Color = [0.95 0.95 0.95];

% Title and labels
title('Stowed Position', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k');
xlabel('X Position [mm]', 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');
ylabel('Y Position [mm]', 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');
zlabel('Z Position [mm]', 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');

% White figure background
set(gcf, 'Color', [1 1 1]);

%% Section 5: Plot 3D Reachable Workspace
function Plot3DReachableWorkspace(a2, a3, a4, theta_1, theta_2, theta_3, theta_4, d5)
    
total_points = length(theta_1) * length(theta_2) * length(theta_3) * length(theta_4) * length(d5);
    X = zeros(1, total_points); Y = zeros(1, total_points); Z = zeros(1, total_points);
    counter = 1;

    % Loop through variable ranges to plot all scatter points
    for t1 = theta_1
        for t2 = theta_2
            for t3 = theta_3
                for t4 = theta_4
                    for d = d5
                        % shorthand equations to shorten statements
                        t23 = t2 + t3;
                        t234 = t2 + t3 + t4;
                        Px_factor = a2*cosd(t2) + a3*cosd(t23) + a4*cosd(t234) - d*sind(t234);

                        X(counter) = cosd(t1) * Px_factor;
                        Y(counter) = sind(t1) * Px_factor;
                        Z(counter) = -a2*sind(t2) - a3*sind(t23) - a4*sind(t234) - d*cosd(t234);
                        counter = counter + 1;
                    end
                end
            end
        end
    end
    X = X(1:counter-1); Y = Y(1:counter-1); Z = Z(1:counter-1);


    % Find workspace volume
    % Uses a tight boundary envelope to calculate volume for non-convex point clouds
    [~, ws_volume] = boundary(X(:), Y(:), Z(:));
    fprintf('Calculated Reachable Workspace Volume:\n');
    fprintf('  %.2f mm^3\n', ws_volume);
    fprintf('  %.5f m^3\n', ws_volume * 1e-9); % Converts mm^3 to m^3

    % 3D Plotting
    figure('Color', [1 1 1]);
    plotColor = [0.2, 0.4, 0.6];
    scatter3(X, Y, Z, 3, plotColor, 'filled', 'MarkerFaceAlpha', 0.1);
    hold on;

    % Representative AUV
    vertices = [
         200,  -100, -100;
         200,   100, -100;
         200,   100,  100;
         200,  -100,  100;
        -800,  -100, -100;
        -800,   100, -100;
        -800,   100,  100;
        -800,  -100,  100
    ];
    faces = [
        1, 2, 3, 4;  5, 6, 7, 8;  1, 2, 6, 5;
        2, 3, 7, 6;  3, 4, 8, 7;  4, 1, 5, 8
    ];
    patch('Vertices', vertices, 'Faces', faces, ...
        'FaceColor', [0.5, 0.5, 0.5], ...
        'FaceAlpha', 0.4, ...
        'EdgeColor', 'k', ...
        'LineWidth', 1.5);

    % Origin green dot
    plot3(0, 0, 0, 'go', ...
        'MarkerSize', 10, ...
        'MarkerFaceColor', 'g', ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 1.5);

    grid on; axis equal; view(45, 30);

    % Axis font and color
    ax = gca;
    ax.FontSize = 14;
    ax.FontWeight = 'bold';
    ax.XColor = [0 0 0];
    ax.YColor = [0 0 0];
    ax.ZColor = [0 0 0];
    ax.GridColor = [0 0 0];
    ax.GridAlpha = 0.3;
    ax.Color = [0.95 0.95 0.95];

    % Title and labels
    title('Reachable Workspace', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k');
    xlabel('X Position [mm]', 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');
    ylabel('Y Position [mm]', 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');
    zlabel('Z Position [mm]', 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');

    % White figure background
    set(gcf, 'Color', [1 1 1]);
end




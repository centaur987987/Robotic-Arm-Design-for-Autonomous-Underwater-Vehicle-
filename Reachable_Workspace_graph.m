% Name: Andrew Centa
% Objective: Plot the reachable workspaces for each position given 
% length and angle inputs

%% Lengths
% Length Variables
L1=100;
L2=450;
L3=510;
L4=380;

%% Code for Collection Position
close all

% Angle range variables
theta_1=90;
theta_2=[-8:-1:-90];  
theta_3=[-8:-1:-140]; 

% Prismatic range
dL4=[1:1:L4];

PlotReachableWorkspace(L1, L2, L3, theta_1, theta_2, theta_3, dL4)

%% Code for storing position
close all

% Angle range variables
theta_1=180;
theta_2=[-8:-1:-140];  
theta_3=[-8:-1:-160]; 

% Prismatic range
dL4=[1:1:50];

% ndgrid
PlotReachableWorkspace(L1, L2, L3, theta_1, theta_2, theta_3, dL4)
hold on
plotStorage()

%% Code for Storage Position
close all

% Angle range variables (Static point)
theta_1=180;
theta_2=[-8.96];
theta_3=[-171.24];

%theta_1=[0:5:90];
%theta_2=[-8:-5:-90];  
%theta_3=[-8:-5:-140]; 


% Prismatic range (Static point)
dL4=[1];

% Origin (Base Joint 1)
X0 = 0;
Y0 = 0;

% Joint 2 Position (End of Link 1)
X1 = L1 * cosd(theta_1);
Y1 = L1 * sind(theta_1);

% Joint 3 Position (End of Link 2)
X2 = X1 + L2 * cosd(theta_1 + theta_2);
Y2 = Y1 + L2 * sind(theta_1 + theta_2);

% End-Effector Position (End of Link 3 + Prismatic extension dL4)
X3 = X2 + (L3 + dL4) * cosd(theta_1 + theta_2 + theta_3);
Y3 = Y2 + (L3 + dL4) * sind(theta_1 + theta_2 + theta_3);

% --- PLOTTING ---

figure;
hold on;

% 1. Plot the linkage lines (Connects points sequentially: Base -> J2 -> J3 -> Tip)
plot([X0, X1, X2, X3], [Y0, Y1, Y2, Y3], 'r-o', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', 'k');

% 2. Keep your original end-effector scatter point on top for tracking consistency
scatter(X3, Y3, 40, 'b', 'filled'); 
hold on 
plotAUV()

title('Robot Linkage Stowed Position')
xlabel('X Position [mm]')
ylabel('Y Position [mm]')
grid on
axis equal

% Expand plot boundaries slightly so the line segments are clearly visible
xlim([min([X0,X1,X2,X3])-100, max([X0,X1,X2,X3])+225]);
ylim([min([Y0,Y1,Y2,Y3])-125, max([Y0,Y1,Y2,Y3])+100]);

%% Reachable Workspace Function

function PlotReachableWorkspace(L1, L2, L3, theta_1, theta_2, theta_3, dL4)
    % ndgrid
    [T1, T2, T3, DL4] = ndgrid(theta_1, theta_2, theta_3, dL4);
    
    % Pre-calculate T12 and T123
    T12  = T1 + T2;
    T123 = T1 + T2 + T3;
    
    % Forward kinematic equations
    X_all = L1*cosd(T1) + L2*cosd(T12) + (L3 + DL4).*cosd(T123);
    Y_all = L1*sind(T1) + L2*sind(T12) + (L3 + DL4).*sind(T123);
    % Flatten matrices into 1D vectors for plotting
    X_flat = X_all(:);
    Y_flat = Y_all(:);
    
    % Plot as scatter plot
    figure;
    scatter(X_flat, Y_flat, 2, 'b', 'filled'); 
    % hold on for AUV rectangle
    hold on;
    % plot AUV rectangle
    plotAUV();

    title('Reachable Workspace')
    xlabel('X Position [mm]')
    ylabel('Y Position [mm]')
    grid on
    axis equal
end

% plot the AUV
function plotAUV()
    % Position: [Left_X, Bottom_Y, Width, Height]
    rectPos = [-700, -100, 900, 200]; 
    
    % Plot the rectangle
    rectangle('Position', rectPos, 'EdgeColor', 'c', 'LineWidth', 2);
    
    % Optional: Label the origin (0,0) for reference
    hold on;
    plot(0, 0, 'gx', 'MarkerSize', 10, 'LineWidth', 2);
    %text(-50, 0, 'BASE', 'HorizontalAlignment', 'right', 'Color', 'g');
    text(-750, 0, 'AUV', 'HorizontalAlignment', 'right', 'Color', 'c');
    hold off;
end

% Plot the storage volume
function plotStorage()
    % Position: [Left_X, Bottom_Y, Width, Height]
    rectPos = [75, 0, 75, 100]; 
    
    % Plot the rectangle
    rectangle('Position', rectPos, 'EdgeColor', 'r', 'LineWidth', 2);
end
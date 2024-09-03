% Load and round Perf time, generate Perf table (nx2)
load("D:\UCData\293\01\Perfusion,na,Numeric,Float,Bowman,data_part1of1");
Perf = [round(time_vector)', measurement_data]; 

% Load and round CPP time, generate CPP table (mx2)
load("D:\UCData\293\01\CPP,na,Numeric,Float,IntelliVue,data_part1of1");
CPP = [round(time_vector)', measurement_data];

% Load and round ICP time, generate ICP table (mx2)
load("D:\UCData\293\01\ICP,Mean,Numeric,Float,IntelliVue,data_part1of1");
ICP = [round(time_vector)', measurement_data];

% Load and round MAP time, generate MAP table (mx2)
load("D:\UCData\293\01\ABP,Mean,Numeric,Float,IntelliVue,data_part1of1");
MAP = [round(time_vector)', measurement_data];

% Load and round O2 time, generate O2 table (mx2)
load("D:\UCData\293\01\UVP,Mean,Numeric,Float,IntelliVue,data_part1of1");
O2 = [round(time_vector)', measurement_data];

% Load PRx data from MAT file
load('D:\UCData\293\01\PRx,na,Numeric,Float,Envision Plugins,I1=ICP (IntelliVue),L1=na,I2=ABP (IntelliVue),L2=na,AW=10s,CW=5m,data_part1of1');
PRx = [round(time_vector)', measurement_data];

% Load DeltaTi data
load("D:\UCData\293\01\PerfDeltaT,na,Numeric,Float,Bowman,data_part1of1");
DeltaTi = [round(time_vector)', measurement_data];

% Load K (conductivity) data
load("D:\UCData\293\01\PerfK,na,SparseNumeric,Float,Bowman,data_part1of1");
K = [round(time_vector)', measurement_data];

% Load PPA data
load("D:\UCData\293\01\PerfPPA,na,SparseNumeric,Float,Bowman,data_part1of1");
PPA = [round(time_vector)', measurement_data];

% Load HR data
load("D:\UCData\293\01\HR,na,Numeric,Float,IntelliVue,data_part1of1");
HR = [round(time_vector)', measurement_data];

% Load Temperature data
load("D:\UCData\293\01\Temp,na,Numeric,Float,IntelliVue,data_part1of1");
Temperature = [round(time_vector)', measurement_data];

% Load Tcore data (for Temp-Tcore subplot)
% Assuming Tcore data needs to be loaded as well
% Load a file for Tcore data (if available)
if exist('D:\UCData\293\01\Tcore,na,Numeric,Float,IntelliVue,data_part1of1.mat', 'file')
    load("D:\UCData\293\01\Tcore,na,Numeric,Float,IntelliVue,data_part1of1");
    Tcore = [round(time_vector)', measurement_data];
else
    Tcore = []; % Empty if no Tcore data file
end

% Create figure for dashboard
figure('Position', [50, 50, 1200, 800]);

%% Relevant numbers: Perfusion (CBF), DeltaTi, K, PPA
subplot(3, 4, 1);

% Draw a blue square
rectangle('Position', [0.2, 0.2, 0.6, 0.6], 'FaceColor', 'blue', 'EdgeColor', 'none');

% Display data values inside the square
if size(Perf, 2) >= 2 && size(DeltaTi, 2) >= 2 && size(K, 2) >= 2 && size(PPA, 2) >= 2
    data_text = sprintf('Perfusion (CBF): %.2f\nDeltaTi: %.2f\nK: %.2f\nPPA: %.2f', ...
        mean(Perf(:,2)), mean(DeltaTi(:,2)), mean(K(:,2)), mean(PPA(:,2)));
    text(0.5, 0.5, data_text, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 14, 'Color', 'black');
else
    text(0.5, 0.5, 'Data not available', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 14, 'Color', 'red');
end

axis off;

%% CBF over time histogram
subplot(3, 4, 2);
if size(Perf, 2) >= 2
    histogram(Perf(:,2), 'Normalization', 'probability');
    title('CBF');
else
    cla;
    title('CBF');
end

%% Temperature over time histogram
subplot(3, 4, 3);
if size(Temperature, 2) >= 2
    histogram(Temperature(:,2), 'Normalization', 'probability');
    title('Temperature');
else
    cla;
    title('Temperature');
end

%% Temperature - Tcore histogram
subplot(3, 4, 4);
if size(Temperature, 2) >= 2 && ~isempty(Tcore) && size(Tcore, 2) >= 2
    histogram(Temperature(:,2) - Tcore(:,2), 'Normalization', 'probability');
    title('Temperature - Tcore');
else
    cla;
    title('Temperature - Tcore');
end

% Conductivity (K) graph
subplot(3, 4, 8);
if size(K, 2) >= 2
    valid_K_indices = K(:,2) ~= -1;
    K_filtered = K(valid_K_indices, :);
    
    plot(K_filtered(:,2), 'b.-');
    title('Conductivity (K)');
    xlabel('Time');
    grid on;
else
    cla;
    title('Conductivity (K)');
end

%% Water content graph
subplot(3, 4, 12);
cla;  % Clear current plot
title('Water Content');
% Display a blank graph with title

%% Streaming data
% Adjusting vertical positions and height to add space between plots
vertical_spacing = 0.02; % Space between plots

% Stream 6: CBF and O2 vs time (two metrics in separate colors)
subplot('Position', [0.1, 0.1 + (5-0)*(0.07 + vertical_spacing), 0.55, 0.07]);
if size(Perf, 2) >= 2 && size(O2, 2) >= 2
    plot(Perf(:,1), Perf(:,2), 'b.-'); % CBF
    hold on;
    plot(O2(:,1), O2(:,2), 'g.-'); % O2
    legend('CBF', 'O2', 'Location', 'best');
    grid on;
else
    cla;
    title('CBF and O2 vs Time');
end

% Stream 5: Temp and Change in Temp over time
subplot('Position', [0.1, 0.1 + (5-1)*(0.07 + vertical_spacing), 0.55, 0.07]);
if size(Temperature, 2) >= 2
    plot(Temperature(:,1), Temperature(:,2), 'k.-'); % Temp
    hold on;
    plot([NaN; diff(Temperature(:,2))], 'r.-'); % Change in Temp (with NaN for alignment)
    legend('Temp', 'Change in Temp', 'Location', 'best');
    set(gca, 'XTickLabel', []);
else
    cla;
    title('Temp and Change in Temp vs Time');
end

% Stream 4: K and PPA over time
subplot('Position', [0.1, 0.1 + (5-2)*(0.07 + vertical_spacing), 0.55, 0.07]);

% Filter out rows where K or PPA have -1 values
if size(K, 2) >= 2 && size(PPA, 2) >= 2
    valid_K_indices = K(:,2) ~= -1;
    valid_PPA_indices = PPA(:,2) ~= -1;
    
    K_filtered = K(valid_K_indices, :);
    PPA_filtered = PPA(valid_PPA_indices, :);
    
    plot(K_filtered(:,1), K_filtered(:,2), 'b.-'); % K
    hold on;
    plot(PPA_filtered(:,1), PPA_filtered(:,2), 'm.-'); % PPA
    legend('K', 'PPA', 'Location', 'best');
    set(gca, 'XTickLabel', []);
else
    cla;
    title('K and PPA vs Time');
end

% Stream 3: MAP, CPP, and ICP (three different colors) over time
subplot('Position', [0.1, 0.1 + (5-3)*(0.07 + vertical_spacing), 0.55, 0.07]);
if size(MAP, 2) >= 2 && size(CPP, 2) >= 2 && size(ICP, 2) >= 2
    plot(MAP(:,1), MAP(:,2), 'g.-'); % MAP
    hold on;
    plot(CPP(:,1), CPP(:,2), 'c.-'); % CPP
    plot(ICP(:,1), ICP(:,2), 'r.-'); % ICP
    legend('MAP', 'CPP', 'ICP', 'Location', 'best');
    set(gca, 'XTickLabel', []);
else
    cla;
    title('MAP, CPP, and ICP vs Time');
end

% Stream 2: HR vs time
subplot('Position', [0.1, 0.1 + (5-4)*(0.07 + vertical_spacing), 0.55, 0.07]);
if size(HR, 2) >= 2
    plot(HR(:,1), HR(:,2), 'r.-');
    legend('HR', 'Location', 'best');
    set(gca, 'XTickLabel', []);
else
    cla;
    title('HR vs Time');
end

% Stream 1: PRx over time
subplot('Position', [0.1, 0.1 + (5-5)*(0.07 + vertical_spacing), 0.55, 0.07]);
if size(PRx, 2) >= 2
    plot(PRx(:,1), PRx(:,2), 'b.-');
    legend('PRx', 'Location', 'best');
    grid on;
else
    cla;
    title('PRx vs Time');
end

% Title annotation
annotation('textbox', [0.1, 0.62, 0.55, 0.05], 'String', 'Streaming Data', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 14, 'FontWeight', 'bold', 'EdgeColor', 'none');

% Show the dashboard
drawnow;
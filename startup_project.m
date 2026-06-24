%% startup_project.m
% Add all repo folders to the MATLAB path so the .slx model and helper
% scripts can find each other no matter where the user opens MATLAB.
%
%   >> startup_project
%
% Run this once per MATLAB session before opening the Simulink model.
% =====================================================================

repoRoot = fileparts(mfilename('fullpath'));
addpath(repoRoot);
addpath(genpath(fullfile(repoRoot, '02_data')));
addpath(genpath(fullfile(repoRoot, '03_model')));
addpath(genpath(fullfile(repoRoot, '04_studies')));
addpath(genpath(fullfile(repoRoot, '05_reports')));

fprintf('14-DoF full-vehicle model paths added.\n');
fprintf('Next: run the parameter file, then open the .slx model.\n');
fprintf('   >> run(''02_data/parameters/Complete_vehicle_simulation_dof14_model_parameters.m'')\n');
fprintf('   >> open_system(''03_model/Complete_vehicle_simulation_dof14_model.slx'')\n');

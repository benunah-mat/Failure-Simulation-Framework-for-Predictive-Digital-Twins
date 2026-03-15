%% ============================================================
% FAILURE SIMULATION FRAMEWORK FOR PREDICTIVE DIGITAL TWINS
% Main Execution Script
% ============================================================

clc
clear
close all

fprintf('Starting Failure Simulation Framework...\n')

num_machines = 4;
t = 1:12000;
dt = 1;

machines = digital_twin_simulator(num_machines,t,dt);

fleet_failure_ranking(machines)

fprintf('\nSimulation Complete.\n')

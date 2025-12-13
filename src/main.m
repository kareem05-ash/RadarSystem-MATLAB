%% Main Radar Simulation
clear; clc; close all;

run radar_param;
run tx_gen;
run rx_gen;
run mf_freq;     % أو mf_time
run doppler_fft;
run range_detect;
run velocity_detect;
run plt;

disp('===== RADAR SIMULATION COMPLETED SUCCESSFULLY =====');
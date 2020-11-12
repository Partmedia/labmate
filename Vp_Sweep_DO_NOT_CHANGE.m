close all
clc

%% Set Parameters

% Vp sweep range
Vp_start = 3; % Vp Sweeping starting point
Vp_step = 2; % Vp step
Vp_Stop = 7; % Vp Sweeping ending point
v_port = 1; % Output port number of voltage source

pwr_start = -40;
pwr_step = 10;
pwr_stop = -20;

% Set VNA parameters
fc = 61.43e6; % center frequency
span = 100e3; % frequency span
num_point = 1601; % number of points
if_bw = 1e2; % IF BW
stress_chann = 1; % stimulating channel
sense_chann = 2; % sensing channel

% Local file save name
lo_file_name = 'T';
lo_file_number = '0';

%% DO NOT CHANGE ANYTHING BELOW THIS LINE
OpenInstruments

sweep_type = ' LIN'; % sweep type
file_name = 'test.s2p'; % saved file name

fprintf(VNA,':SYST:PRES');% Reset VNA
fprintf(VNA, ':TRIG:SOUR BUS');% Set trigger source to BUS

for power = pwr_start:pwr_step:pwr_stop
    for v_target = Vp_start:Vp_step:Vp_Stop % Start Sweeping
        E5071X_CTRL_VpSweep_v1_DO_NOT_CHANGE;
    end
end

Turn_Down_Voltage_DO_NOT_CHANGE
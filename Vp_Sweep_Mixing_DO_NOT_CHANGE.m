close all
clear all
clc

%% Construct visa object

% Tool Name                  GPIB#
% NG-VS-03                    1
% NG-NA-03                    16

%% Create VISA Objects
VNA = visa('ni', 'GPIB0::16::INSTR');
VS_03 = visa('ni','GPIB0::1::INSTR');

%% Set Parameters

% Vp sweep range

Vp_start = 1; % Vp Sweeping starting point
Vp_step = 0.5; % Vp step
Vp_Stop = 1; % Vp Sweeping ending point
v_port = 1; % Output port number of voltage source

% Set Mixing parameters

mix_output_channel = 1; % Channel select
mix_vpp = 762; % Peak-to-peak voltage in mV
mix_freq = 15; % LO frequency in MHz
mix_impedance = 1e6; % Load impedance of the function generator: enter 50 for 50 Ohm, 1e6 for High-Z
mix_ramp_step = 50; % Voltage step during ramp-up
mix_ramp_down = 50; % Voltage step during ramp-down
mix_ramp_wait_time = 0.1; % Wait time between steps for ramp-up and ramp-down

% Set VNA parameters

fc = 50e6; % center frequency
span = 10e6; % frequency span
num_point = 1601; % number of points
power = -50; % power level
if_bw = 1e2; % IF BW
stress_chann = 1; % stimulating channel
sense_chann = 3; % sensing channel

% Local file save name
lo_file_name = 'T';
lo_file_number = '0';

AFG3102_CTRL_VpSweepMixing_DO_NOT_CHANGE;

%% DO NOT CHANGE ANYTHING BELOW THIS LINE
while(true)
    %% DO NOT CHANGE
    
    sweep_type = ' LIN'; % sweep type
    file_name = 'test.s2p'; % saved file name
    
    % Set Voltage source parameters
    %v_target = 1.5;
    v_step = 0.1;
    v_time_step = 0.5;
    v_tolerance = 1e-2;
    v_lim_up = 15;
    v_lim_btm = 0;
    inc = true;
    dec = ~inc;
    
    %% DO NOT CHANGE - Set VNA parameter
    VNA.InputBufferSize = 1601*40;
    VNA.Timeout = 600;
    
    fopen(VNA); % VNA
    fopen(VS_03); % Voltage Source
    fprintf(VNA,':SYST:PRES');% Reset VNA
    
    fprintf(VNA, ':TRIG:SOUR BUS');% Set trigger source to BUS
    
    for v_target = Vp_start:Vp_step:Vp_Stop % Start Sweeping
        E5071X_CTRL_VpSweep_v1_DO_NOT_CHANGE;
    end
    
    fclose(VNA);
    fclose(VS_03);
    
    Turn_Down_Voltage_DO_NOT_CHANGE
    break;
end
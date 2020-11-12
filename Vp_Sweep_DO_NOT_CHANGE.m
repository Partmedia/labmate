close all
clc

%% Set Parameters

% Vp sweep range
Vp_start = 1; % Vp Sweeping starting point
Vp_step = 2; % Vp step
Vp_Stop = 7; % Vp Sweeping ending point
v_port = 1; % Output port number of voltage source

pwr_start = -40;
pwr_step = 10;
pwr_stop = -10;
pwr_levels = [-40, -30, -20, -10, -5];

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
fprintf(VNA, ':TRIG:SOUR BUS');% Set trigger source to BUS

file_name = 'test.s2p'; % saved file name

for power = pwr_levels
    E5071X_Setup(VNA, fc, span, num_point, if_bw, power, stress_chann, sense_chann);
    for v_target = Vp_start:Vp_step:Vp_Stop
        fprintf("%.1f dBm @ Vp=%.1f ", power, v_target);
        Set_Voltage(VS_03, v_port, v_target)
        imeas = str2double(query(VS_03,'MEAS:CURR?')) * 1000;
        fprintf("(%.2f mA) ", imeas);
        if (imeas > 1)
            Turn_Down_Voltage_DO_NOT_CHANGE
            throw MException("Vp short detected!")
        end
        E5071X_CTRL_VpSweep_v1_DO_NOT_CHANGE;
        fprintf("OK\n");
    end
end

Turn_Down_Voltage_DO_NOT_CHANGE
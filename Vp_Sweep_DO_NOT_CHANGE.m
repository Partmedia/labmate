close all
clc

%% Set Parameters
vsource = VS_05;
stress_chann = 1;   % Stimulus channel
sense_chann = 2;    % Sense channel
v_port = 1;         % Output port number of voltage source
vp_sweep = 0:1:18;  % Vp sweep range (start:step:stop)
pwr_levels = [-30, -15, -12.5]; % Power sweep range (dBm)
mix = 0;            % Do mixed measurement

% Set VNA parameters
fc = 61.108942e6; % center frequency
span = 100e3; % frequency span
num_point = 1601; % number of points
if_bw = 200; % IF BW

% Local file save name
lo_file_name = input('Device ID? ', 's');
lo_file_number = '0';

%% DO NOT CHANGE ANYTHING BELOW THIS LINE
OpenInstruments
Turn_Down_Voltage_DO_NOT_CHANGE
fprintf(VNA, ':TRIG:SOUR BUS');% Set trigger source to BUS

for power = pwr_levels
    tic
    % Vp sweep
    f_lo = 0;
    vpp_lo = 0;
    out_harm = 0;
    for rev = [0, 1]
    E5071X_Setup(VNA, fc, span, num_point, if_bw, power, stress_chann, sense_chann, 0, rev);
    for v_target = vp_sweep
        fprintf("%.1f dBm @ Vp=%.1f %d ", power, v_target, rev);
        Set_Voltage(vsource, v_port, v_target);
        check_vp(vsource);
        E5071X_CTRL_VpSweep_v1_DO_NOT_CHANGE;
        fprintf("OK\n");
    end
    end
    
    % Mixed measurement
    if (mix)
        f_lo = 15e6;
        vpp_lo = 5;
        for v_target = [3, 5]
            for out_harm = [0, 1]
                fprintf("%.1f dBm @ Vp=%.1f mix %.1f (out %d) ", power, v_target, vpp_lo, out_harm);
                AFG3102_Setup(lo, 1, vpp_lo, f_lo)
                Set_Voltage(vsource, v_port, v_target)
                check_vp(vsource)
                E5071X_Setup(VNA, fc, span, num_point, if_bw, power, stress_chann, sense_chann, out_harm * f_lo);
                E5071X_CTRL_VpSweep_v1_DO_NOT_CHANGE;
                fprintf("OK\n");
            end
        end
        AFG3102_Setup(lo, 1, 0, f_lo)
    end
    toc
end

Turn_Down_Voltage_DO_NOT_CHANGE

function check_vp(vsource)
    imeas = str2double(query(vsource,'MEAS:CURR?')) * 1000;
    fprintf("(%.2f mA) ", imeas);
    if (imeas > 1)
        Turn_Down_Voltage_DO_NOT_CHANGE
        throw MException("Vp short detected!")
    end
end
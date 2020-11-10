close all
clear all
clc

%% Configure visa object and open 

obj1 = visa('ni','GPIB0::11::INSTR'); % Configure visa object

fopen(obj1);

fprintf(obj1,'OUTP1:STAT OFF'); % Set output of Channel 1 to OFF

fprintf(obj1,'OUTP2:STAT OFF'); % Set output of Channel 2 to OFF

%% Waveform setting

output_channel = 1; % Channel select
mix_vpp = 762; % Peak-to-peak voltage in mV
mix_freq = 15; % LO frequency in MHz
impedance = 1e6; % Load impedance of the function generator: enter 50 for 50 Ohm, 1e6 for High-Z

set_mix_imp = strcat('OUTP',num2str(output_channel),':IMP',{' '},num2str(impedance));
fprintf(obj1,set_mix_imp{1}); % Set frequency of selected channel

set_mix_voltage = strcat('SOUR',num2str(output_channel),':VOLT',{' '},num2str(mix_vpp/1e3));
fprintf(obj1,set_mix_voltage{1}); % Set voltage of selected channel

set_mix_freq = strcat('SOUR',num2str(output_channel),':FREQ',{' '},num2str(mix_freq*1e6));
fprintf(obj1,set_mix_freq{1}); % Set frequency of selected channel


%% Turn on output of selected channel

fprintf(obj1,strcat('OUTP',num2str(output_channel),':STAT ON'));

%% Exit and close

fprintf(obj1,strcat('OUTP',num2str(output_channel),':STAT OFF'));

fclose(obj1);
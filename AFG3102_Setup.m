function AFG3102_Setup(obj1, channel, vpp, freq)
if (vpp == 0)
    fprintf(obj1,'OUTP%d:STAT OFF', channel);
    return;
end

impedance = 1e6; % Load impedance of the function generator: enter 50 for 50 Ohm, 1e6 for High-Z
set_mix_imp = strcat('OUTP',num2str(channel),':IMP',{' '},num2str(impedance));
fprintf(obj1,set_mix_imp{1});

set_mix_voltage = strcat('SOUR',num2str(channel),':VOLT',{' '},num2str(vpp));
fprintf(obj1,set_mix_voltage{1});

set_mix_freq = strcat('SOUR',num2str(channel),':FREQ',{' '},num2str(freq));
fprintf(obj1,set_mix_freq{1});

%% Turn on output of selected channel
fprintf(obj1,strcat('OUTP',num2str(channel),':STAT ON'));
end
%% Run Measurement
fprintf(VNA, 'TRIG:SING');

%% Wait until measurement is done
pause(0.5)
fprintf(VNA, ':DISP:WIND1:TRAC1:Y:AUTO');
query(VNA, '*OPC?');

%% Auto Scale
fprintf(VNA, ':DISP:WIND1:TRAC1:Y:AUTO');

%% Save SnP
fprintf(VNA, 'DISP:WIND:ACT');
fprintf(VNA, 'MMEM:STOR:SNP:FORM RI');

set_snp = strcat('MMEM:STOR:SNP:TYPE:S2P',{' '},num2str(stress_chann),',',num2str(sense_chann));
set_snp = set_snp{1};
fprintf(VNA, set_snp);

%fprintf(VNA, strcat(':MMEM:STOR:SN','P "',file_name,'"'));


%% Retreive data
freq_out = query(VNA, ':SENS1:FREQ:DATA?');
fprintf(VNA, strcat('CALC1:FORM MLOG'));
mag_out = query(VNA, ':CALC1:DATA:FDAT?');
fprintf(VNA, strcat('CALC1:FORM PHAS'));
phs_out =  query(VNA, ':CALC1:DATA:FDAT?');

%% Format data
mag_f = str2double(strsplit(mag_out,','));
freq_f = str2double(strsplit(freq_out,','));
phs_f = str2double(strsplit(phs_out,','));

mag_fordered = 1:1:numel(mag_f)/2;
phs_fordered = mag_fordered;
for n = 1:1:numel(mag_fordered)
    mag_fordered(n) = mag_f(2*n-1);
    phs_fordered(n) = phs_f(2*n-1);
end

%% Plot data
plot(freq_f,mag_fordered);
hold on
% yyaxis right
% plot(freq_f,phs_fordered);

%% Save data
if (vpp_lo == 0)
    tosave_file_name = sprintf("T_P%.1f_Vp%.1f.mat", power, v_target);
else
    tosave_file_name = sprintf("T_P%.1f_Vp%.1f_MixVpp%.1f_Out%d.mat", power, v_target, vpp_lo, out_harm);
end
save(tosave_file_name, 'v_target', 'power', 'if_bw', 'freq_f', 'mag_fordered', 'phs_fordered', 'f_lo', 'vpp_lo', 'out_harm');
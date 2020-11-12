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
lo_file_number_temp = 0;

while(true)
    while(true)
        num_toinsert = 4-floor(log10(lo_file_number_temp));
        if(num_toinsert == Inf)
            lo_file_number = '00000';
            break;
        else
            while(num_toinsert > 0.5 && num_toinsert ~= Inf)
                num_toinsert = num_toinsert - 1;
                lo_file_number = strcat('0',lo_file_number);
            end
            break;
        end
    end

    tosave_file_name = strcat(lo_file_name,lo_file_number);
    if(isfile(strcat(tosave_file_name,'.mat')) == 0)
        lo_file_number_temp = str2double(lo_file_number);
        % Insert '0'
        
        num_toinsert = 4-floor(log10(lo_file_number_temp));
        if(num_toinsert == Inf)
            lo_file_number = '00000';
        end
        save(strcat(lo_file_name,lo_file_number), 'v_target', 'power', 'if_bw', 'freq_f', 'mag_fordered', 'phs_fordered');
        break;
    else
        lo_file_number_temp = str2double(lo_file_number);
        lo_file_number_temp = lo_file_number_temp+1;
        lo_file_number = num2str(lo_file_number_temp);
    end
end
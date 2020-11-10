figure

tic
%% Construct visa object

% Tool Name                  GPIB#
% NG-VS-03                    1
% NG-NA-03                    17                   

% VNA = visa('ni', 'GPIB0::16::INSTR');
% VS_03 = visa('ni','GPIB0::1::INSTR');
% 
% VNA.InputBufferSize = 1601*40;
% VNA.Timeout = 600;
% 
% fopen(VNA); % VNA
% fopen(VS_03); % Voltage Source
% fprintf(VNA,':SYST:PRES');
% 
% %% Set trigger source to BUS
% 
% fprintf(VNA, ':TRIG:SOUR BUS');
% %% Set Parameters
% 
% % Set VNA parameters
% 
% fc = 50e6; % center frequency
% span = 10e6; % frequency span
% num_point = 1601; % number of points
% power = -50; % power level
% if_bw = 1e2; % IF BW
% sweep_type = ' LIN'; % sweep type
% stress_chann = 1; % stimulating channel
% sense_chann = 3; % sensing channel
% file_name = 'test.s2p'; % saved file name
% 
% % Set Voltage source parameters
% 
% v_port = 1;
% %v_target = 1.5;
% v_step = 0.1;
% v_time_step = 0.5;
% v_tolerance = 1e-2;
% v_lim_up = 15;
% v_lim_btm = 0;
% inc = true;
% dec = ~inc;
% 
% % Local file save name
% lo_file_name = 'T';
% lo_file_number = '0';

%% Set Voltage 

% Set Voltage Step

set_volt_port = strcat('INST:SEL OUT',num2str(v_port));
fprintf(VS_03, set_volt_port);

set_volt_step = strcat('VOLT:STEP',{' '},num2str(v_step));
set_volt_step = set_volt_step{1};
fprintf(VS_03, set_volt_step);

outp_stat = str2double(query(VS_03,'OUTP?'));

if(outp_stat == 0)
    fprintf(VS_03, 'VOLT 0');
    fprintf(VS_03, 'OUTP ON');
    while(str2double(query(VS_03,'VOLT?')) < v_target - v_tolerance)
        pause(v_time_step)
        if(str2double(query(VS_03,'VOLT?')) >= v_lim_up)
            break;
        end
        fprintf(VS_03, 'VOLT UP');
    end
end

if(inc)
    
if(outp_stat==1)
    curr_volt = str2double(query(VS_03,'VOLT?'));
    while(curr_volt < v_target - v_tolerance)
        pause(v_time_step)
        if(curr_volt >= v_lim_up)
            break;
        end
        fprintf(VS_03, 'VOLT UP');
        curr_volt = str2double(query(VS_03,'VOLT?'));
    end
end


else
    
if(outp_stat==1)
    curr_volt = str2double(query(VS_03,'VOLT?'));
    while(curr_volt < v_target - v_tolerance)
        pause(v_time_step)
        if(curr_volt >= v_lim_btm)
            break;
        end
        fprintf(VS_03, 'VOLT DOWN');
        curr_volt = str2double(query(VS_03,'VOLT?'));
    end
end

end

%% Set Sweep Type

set_swe_typ_stress = strcat(':SENS',num2str(stress_chann),':SWE:TYPE',sweep_type);
set_swe_typ_sense = strcat(':SENS',num2str(sense_chann),':SWE:TYPE',sweep_type);

%% Set Center Frequency

set_center = strcat(':SENS',num2str(stress_chann),':FREQ:CENT',{' '},num2str(fc));
set_center_stress = set_center{1};
set_center = strcat(':SENS',num2str(sense_chann),':FREQ:CENT',{' '},num2str(fc));
set_center_sense = set_center{1};

%% Set Frequency Span

set_span = strcat(':SENS',num2str(stress_chann),':FREQ:SPAN',{' '},num2str(span));
set_span_stress = set_span{1};
set_span = strcat(':SENS',num2str(sense_chann),':FREQ:SPAN',{' '},num2str(span));
set_span_sense = set_span{1};

%% Set Number of Points

set_point = strcat(':SENS',num2str(stress_chann),':SWE:POIN',{' '},num2str(num_point));
set_point_stress = set_point{1};
set_point = strcat(':SENS',num2str(sense_chann),':SWE:POIN',{' '},num2str(num_point));
set_point_sense = set_point{1};

%% Set IF BW

set_if = strcat(':SENS',num2str(stress_chann),':BAND',{' '},num2str(if_bw));
set_if_stress = set_if{1};
set_if = strcat(':SENS',num2str(sense_chann),':BAND',{' '},num2str(if_bw));
set_if_sense = set_if{1};

%% Set Power

set_pw = strcat(':SOUR',num2str(stress_chann),':POW',{' '},num2str(power));
set_pw_stress = set_pw{1};
set_pw = strcat(':SOUR',num2str(sense_chann),':POW',{' '},num2str(power));
set_pw_sense = set_pw{1};

%%

fprintf(VNA, set_swe_typ_stress);
fprintf(VNA, set_swe_typ_sense);

fprintf(VNA, set_center_stress);
fprintf(VNA, set_center_sense);

fprintf(VNA, set_span_stress);
fprintf(VNA, set_span_sense);

fprintf(VNA, set_point_stress);
fprintf(VNA, set_point_sense);

fprintf(VNA, set_if_stress);
fprintf(VNA, set_if_sense);

fprintf(VNA, set_pw_stress);
fprintf(VNA, set_pw_sense);

fprintf(VNA, strcat('CALC1:PAR1:DEF S',num2str(sense_chann),num2str(stress_chann)));
fprintf(VNA, strcat('CALC1:PAR1:SEL'));
fprintf(VNA, strcat('CALC1:FORM MLOG'));




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

data_o = [freq_f;mag_fordered;phs_fordered]';

%% Plot data

plot(freq_f,mag_fordered);
hold on
yyaxis right
plot(freq_f,phs_fordered);


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
            save(strcat(lo_file_name,lo_file_number));
        end
        save(strcat(lo_file_name,lo_file_number));
        break;
    else
        lo_file_number_temp = str2double(lo_file_number);
        lo_file_number_temp = lo_file_number_temp+1;
        lo_file_number = num2str(lo_file_number_temp);
    end
end

%% Closing


toc

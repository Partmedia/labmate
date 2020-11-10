% Set Voltage source to 0 and turn off output
VS_03 = visa('ni','GPIB0::1::INSTR');

turn_off_tolerance = 0.09;
v_step = 0.09;
v_time = 0.5;

fopen(VS_03); % Voltage Source

fprintf(VS_03,'INST:SEL OUT1');

set_volt_step = strcat('VOLT:STEP',{' '},num2str(v_step));
set_volt_step = set_volt_step{1};
fprintf(VS_03, set_volt_step);


outp_stat = str2double(query(VS_03,'OUTP?'));
if(outp_stat == 1)
    while(true)
    curr_volt = str2double(query(VS_03,'VOLT?'));
        if(curr_volt <= turn_off_tolerance)
            break;
        else
            fprintf(VS_03, 'VOLT DOWN');
            pause(v_time);
        end
    end
end
fprintf(VS_03,'VOLT 0');
fprintf(VS_03,'OUTP OFF');


fprintf(VS_03,'INST:SEL OUT2');

set_volt_step = strcat('VOLT:STEP',{' '},num2str(v_step));
set_volt_step = set_volt_step{1};
fprintf(VS_03, set_volt_step);

outp_stat = str2double(query(VS_03,'OUTP?'));
if(outp_stat == 1)
    while(true)
    curr_volt = str2double(query(VS_03,'VOLT?'));
        if(curr_volt <= turn_off_tolerance)
            break;
        else
            fprintf(VS_03, 'VOLT DOWN');
            pause(v_time);
        end
    end
end
fprintf(VS_03,'VOLT 0');
fprintf(VS_03,'OUTP OFF');
fclose(VS_03);
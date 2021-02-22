function Set_Voltage(VS_03, v_port, v_target)
v_lim_btm = 0;
v_lim_up = 15;
v_step = 0.2;
v_tolerance = v_step;
i_lim = 10e-3;

% Limit v_target between (v_limit_btm, v_limit_up)
v_target = min(v_lim_up, max(v_lim_btm, v_target));

% Select port
set_volt_port = strcat('INST:SEL OUT',num2str(v_port));
fprintf(VS_03, set_volt_port);

% Set voltage step
set_volt_step = strcat('VOLT:STEP',{' '},num2str(v_step));
set_volt_step = set_volt_step{1};
fprintf(VS_03, set_volt_step);

% Enable output
outp_stat = str2double(query(VS_03,'OUTP?'));
if(outp_stat == 0 && v_target ~= 0)
    fprintf(VS_03, 'CURR %.3f', i_lim);
    fprintf(VS_03, 'VOLT 0');
    fprintf(VS_03, 'OUTP ON');
end

curr_volt = str2double(query(VS_03,'VOLT?'));
while(abs(curr_volt - v_target) > v_tolerance)
    if(curr_volt < v_target)
        fprintf(VS_03, 'VOLT UP');
    else
        fprintf(VS_03, 'VOLT DOWN');
    end
    
    curr_volt = str2double(query(VS_03,'VOLT?'));
end

fprintf(VS_03, "VOLT %.2f", v_target);

if (v_target == 0)
    fprintf(VS_03, 'OUTP OFF');
    return
end
end

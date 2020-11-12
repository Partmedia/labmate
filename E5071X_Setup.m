function E5071X_Setup(VNA, fc, span, num_point, if_bw, power, stress_chann, sense_chann, offset)
%% Set Sweep Type
sweep_type = ' LIN'; % sweep type
set_swe_typ_stress = strcat(':SENS',num2str(stress_chann),':SWE:TYPE',sweep_type);
set_swe_typ_sense = strcat(':SENS',num2str(sense_chann),':SWE:TYPE',sweep_type);
fprintf(VNA, set_swe_typ_stress);
fprintf(VNA, set_swe_typ_sense);

%% Set Center Frequency
set_center = strcat(':SENS',num2str(stress_chann),':FREQ:CENT',{' '},num2str(fc));
set_center_stress = set_center{1};
set_center = strcat(':SENS',num2str(sense_chann),':FREQ:CENT',{' '},num2str(fc));
set_center_sense = set_center{1};
fprintf(VNA, set_center_stress);
fprintf(VNA, set_center_sense);

%% Set Frequency Span
set_span = strcat(':SENS',num2str(stress_chann),':FREQ:SPAN',{' '},num2str(span));
set_span_stress = set_span{1};
set_span = strcat(':SENS',num2str(sense_chann),':FREQ:SPAN',{' '},num2str(span));
set_span_sense = set_span{1};
fprintf(VNA, set_span_stress);
fprintf(VNA, set_span_sense);

%% Set Number of Points
set_point = strcat(':SENS',num2str(stress_chann),':SWE:POIN',{' '},num2str(num_point));
set_point_stress = set_point{1};
set_point = strcat(':SENS',num2str(sense_chann),':SWE:POIN',{' '},num2str(num_point));
set_point_sense = set_point{1};
fprintf(VNA, set_point_stress);
fprintf(VNA, set_point_sense);

%% Set IF BW
set_if = strcat(':SENS',num2str(stress_chann),':BAND',{' '},num2str(if_bw));
set_if_stress = set_if{1};
set_if = strcat(':SENS',num2str(sense_chann),':BAND',{' '},num2str(if_bw));
set_if_sense = set_if{1};
fprintf(VNA, set_if_stress);
fprintf(VNA, set_if_sense);

%% Set Power
set_pw = strcat(':SOUR',num2str(stress_chann),':POW',{' '},num2str(power));
set_pw_stress = set_pw{1};
set_pw = strcat(':SOUR',num2str(sense_chann),':POW',{' '},num2str(power));
set_pw_sense = set_pw{1};
fprintf(VNA, set_pw_stress);
fprintf(VNA, set_pw_sense);

%% Frequency Offset
if (offset == 0)
    fprintf(VNA, ':SENS1:OFFS OFF');
else
    % zero source offset
    cmd = sprintf('SENS1:OFFS:PORT%d:OFFS %f', stress_chann, 0);
    fprintf(VNA, cmd);
    
    % set sense offset
    cmd = sprintf('SENS1:OFFS:PORT%d:OFFS %f', sense_chann, offset);
    fprintf(VNA, cmd);
    
    fprintf(VNA, ':SENS1:OFFS ON');
end

%%
fprintf(VNA, strcat('CALC1:PAR1:DEF S',num2str(sense_chann),num2str(stress_chann)));
fprintf(VNA, strcat('CALC1:PAR1:SEL'));
fprintf(VNA, strcat('CALC1:FORM MLOG'));
end

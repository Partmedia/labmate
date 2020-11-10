% Tool Name                  GPIB#
% NG-VS-03                    1
% NG-NA-03                    16

if ~exist('VS_03', 'var')
    VS_03 = visa('ni','GPIB0::1::INSTR');
    fopen(VS_03); % Voltage Source
end

if ~exist('VNA', 'var')
    VNA = visa('ni', 'GPIB0::16::INSTR');
    fopen(VNA);
end
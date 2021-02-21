% Tool Name                  GPIB#
% NG-VS-03 (E3649A)            1
% NG-VS-05 (E3649A)            5
% AFG3102                     11
% NG-NA-03 (E5071C)           16

if ~exist('VS_03', 'var')
    VS_03 = visa('ni','GPIB0::1::INSTR');
    fopen(VS_03); % Voltage Source
end

if ~exist('VS_05', 'var')
    VS_05 = visa('ni','GPIB0::5::INSTR');
    fopen(VS_05); % Voltage Source
end

if ~exist('lo', 'var')
    lo = visa('ni','GPIB0::11::INSTR');
    fopen(lo);
end

if ~exist('VNA', 'var')
    VNA = visa('ni', 'GPIB0::16::INSTR');
    VNA.InputBufferSize = 1601*40;
    VNA.Timeout = 600;
    fopen(VNA);
end
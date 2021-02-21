% Set Voltage source to 0 and turn off output
OpenInstruments;
Set_Voltage(vsource, 1, 0);
Set_Voltage(vsource, 2, 0);
if (mix)
    AFG3102_Setup(lo, 1, 0, 15e6);
end
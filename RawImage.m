% Parkinsonion Tremor measurement
% Description: 
%Hand tremor movement using Walabot

% **************** Walablot Setup variables **********************
% Define Arena and Threshold (Where R_in=[R_min,R_max,R_resolution] and similarly for Theta_in and Phi_in )

R_in=[10,100,5];
Theta_in=[-30,30,10];
Phi_in=[-70,70,10];
Threshold=60;

% Walabot API Setup
global API % declaration of API
asm=NET.addAssembly('C:\Program Files\Walabot\WalabotSDK\bin\WalabotAPI.NET.dll'); % Change API file destination accordingly

import WalabotAPI_NET.*;
API = WalabotAPI_NET.WalabotAPI();
API.SetSettingsFolder('C:\ProgramData\Walabot\WalabotSDK');

API.ConnectAny();

% Set Sensor Profile:
PROF_SENSOR=WalabotAPI_NET.APP_PROFILE.PROF_SENSOR;
MTI_Filter=WalabotAPI_NET.FILTER_TYPE.FILTER_TYPE_MTI ;
API.SetProfile(PROF_SENSOR);

% Set Threshold:
API.SetThreshold(Threshold);
% Set Arena:
API.SetArenaR(R_in(1),R_in(2),R_in(3));
API.SetArenaTheta(Theta_in(1),Theta_in(2),Theta_in(3));
API.SetArenaPhi(Phi_in(1),Phi_in(2),Phi_in(3));
% Set Filter Type
API.SetDynamicImageFilter(MTI_Filter);

% Activate walabot sensor (Start and calibrate)
API.Start();
API.GetStatus();
API.StartCalibration();
API.GetStatus();

% Starting Loop
while true
    API.Trigger(); 
    %result=API.GetRawImage;
    Aresult=API.GetRawImageSlice(); % Gathers 2D image of the reflected signal
    Data = int32(result); 
    clf
    Y = fft2(Data); % Converts the signal to frequency domain and plot it
    surf(abs(fftshift(Y)))
    zlim([0 2000])
%     surf(Data);   % Plots Raw Data
%     zlim([0 300])
    pause(0.01)
end

API.Clean  % If API is being used Run this command to close it.

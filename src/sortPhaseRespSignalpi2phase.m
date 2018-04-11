function [data_table] = sortPhaseRespSignalpi2phase(means)
% Respiratory signal extracted from the intensities variations from
% a Region of Interest converted into the phase respiratory signal
% Sorts out any "breathing" images out from a set of ct scans so that the
% reconstruction shows a still diaphram (-pi/8, pi/8)


%%Create the resp signal phase
[resp_phase,~]=resp_signal_phase_fit(means);

%% Breathing cycle sorting by 4 equi-spaced bins (-4pi/8,4pi/8) 
f_s = size(means);
data_table = zeros(1,f_s(2));
y = resp_phase;
figure;
polarhistogram(resp_phase,[-pi,-7*pi/8 pi/8 ,pi]);

for n = 1:f_s(2)
%save files that dont have breathing
 if y(n)>=-7*pi/8 && y(n)<pi/8
     data_table(n) = 1 ; % exhale
 else
     data_table(n) = 2;% inhale
end
 
end


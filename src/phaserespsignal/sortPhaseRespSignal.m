function [data_table] = sortPhaseRespSignal(acqPath, resp_path_dest, means)
% Respiratory signal extracted from the intensities variations from
% a Region of Interest converted into the phase respiratory signal
% Sorts out any "breathing" images out from a set of ct scans so that the
% reconstruction shows a still diaphram (-pi/6, pi/6)

%Author: AOrtega (UC3M)
%Date: 10/11/2017

%%Create the resp signal phase
[resp_phase,resp_amp]=resp_signal_phase_fit(means);

%% Breathing cycle sorting by 6 equi-spaced bins (-7pi/8,7pi/8) 
f_s = size(means);
data_table = zeros(1,f_s(1));
y = resp_phase;
figure;
h = polarhistogram(y,6);

for n = 1:nof
 %save files that dont have breathing
            if y(n)>=h.BinEdges(1)&& y(n)<=h.BinEdges(2)%threshold is set at any means less than 150
                    data_table(n) = 1 ;
            end %for middle files
           
end

end %function

function [data_table] = sortPhaseRespSignal16phase(means)
% Respiratory signal extracted from the intensities variations from
% a Region of Interest converted into the phase respiratory signal
% Sorts out any "breathing" images out from a set of ct scans so that the
% reconstruction shows a still diaphram (-pi/8, pi/8)


%%Create the resp signal phase
[resp_phase,~]=resp_signal_phase_fit(means);

%% Breathing cycle sorting by 9 equi-spaced bins (-pi/8,pi/8) 
f_s = size(means);
data_table = zeros(1,f_s(2));
y = resp_phase;
figure;
h = polarhistogram(y,16);

for n = 1:f_s(2)
 %save files that dont have breathing
 if y(n)>=h.BinEdges(2)&& y(n)<=h.BinEdges(3) || y(n)>=h.BinEdges(3)&& y(n)<=h.BinEdges(4)
     data_table(n) = 1 ; %early exhale
 elseif y(n)>h.BinEdges(4)&& y(n)<=h.BinEdges(5)|| y(n)>=h.BinEdges(5)&& y(n)<=h.BinEdges(6)
     data_table(n) = 2 ;%mid exhale
 elseif y(n)>h.BinEdges(6)&& y(n)<=h.BinEdges(7)|| y(n)>=h.BinEdges(7)&& y(n)<=h.BinEdges(8)
     data_table(n) = 3;% late exhale
  elseif y(n)>h.BinEdges(8)&& y(n)<=h.BinEdges(9)|| y(n)>=h.BinEdges(9)&& y(n)<=h.BinEdges(10)
     data_table(n) = 4;%peak exhale
 elseif y(n)>h.BinEdges(10)&& y(n)<=h.BinEdges(11)|| y(n)>=h.BinEdges(11)&& y(n)<=h.BinEdges(12)
     data_table(n) = 5;%early inhale
 elseif y(n)>h.BinEdges(12)&& y(n)<=h.BinEdges(13)|| y(n)>=h.BinEdges(13)&& y(n)<=h.BinEdges(14)
     data_table(n) = 6;%mid inhale
 elseif y(n)>h.BinEdges(14)&& y(n)<=h.BinEdges(15)|| y(n)>=h.BinEdges(15)&& y(n)<=h.BinEdges(16)
     data_table(n) = 7;%late inhale
 else %y(n)>h.BinEdges(16)&& y(n)<=h.BinEdges(17)|| y(n)>=h.BinEdges(17)&& y(n)<=h.BinEdges(1)
     data_table(n) = 8;%peak inhale
%  else
%      
%      data_table(n) = 8 ;%peak exhale
 end
 
end

end %function

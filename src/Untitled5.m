% for n = 1:f_s(2)
%  %save files that dont have breathing
%  if y(n)>=h.BinEdges(2)&& y(n)<=h.BinEdges(3) || y(n)>=h.BinEdges(3)&& y(n)<=h.BinEdges(4)
%      data_table(n) = 1 ; %mid exhale
%  elseif y(n)>h.BinEdges(4)&& y(n)<=h.BinEdges(5)|| y(n)>=h.BinEdges(5)&& y(n)<=h.BinEdges(6)
%      data_table(n) = 2 ;%early exhale
%  elseif y(n)>h.BinEdges(6)&& y(n)<=h.BinEdges(7)|| y(n)>=h.BinEdges(7)&& y(n)<=h.BinEdges(8)
%      data_table(n) = 3;% peak inhale
%   elseif y(n)>h.BinEdges(8)&& y(n)<=h.BinEdges(9)|| y(n)>=h.BinEdges(9)&& y(n)<=h.BinEdges(10)
%      data_table(n) = 4;%lateinhale
%  elseif y(n)>h.BinEdges(10)&& y(n)<=h.BinEdges(11)|| y(n)>=h.BinEdges(11)&& y(n)<=h.BinEdges(12)
%      data_table(n) = 5;%mid inhale
%  elseif y(n)>h.BinEdges(12)&& y(n)<=h.BinEdges(13)|| y(n)>=h.BinEdges(13)&& y(n)<=h.BinEdges(14)
%      data_table(n) = 6;%early inhale
%  elseif y(n)>h.BinEdges(14)&& y(n)<=h.BinEdges(15)|| y(n)>=h.BinEdges(15)&& y(n)<=h.BinEdges(16)
%      data_table(n) = 7;%peak exhale
%  elseif y(n)>h.BinEdges(16)&& y(n)<=h.BinEdges(17)|| y(n)>=h.BinEdges(17)&& y(n)<=h.BinEdges(1)
%      data_table(n) = 8;%late exhale
% %  else
% %      
% %      data_table(n) = 8 ;%peak exhale

clear
close all

load resp_sig3c.mat;

% [pks,locs] = findpeaks(resp_sig3c);%find peak location in respiratory signal in the whole stack
% %findpeaks(resp_sig3c); title('peaks in respiratory signal');

inresp_sig3c= -resp_sig3c; %calculating invers respiratory signal for bottoms

[bpks,blocs] = findpeaks(inresp_sig3c);%seperating botton peaks in the whole stack
srcfiles = dir('D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.1\*.dcm');
numNames = length(srcfiles);
format long;
if (numNames <= 2)
    error('dcmDir does not contain any files');
end
for k=1:numNames;
    ResortedDataNew{k}=srcfiles(k).name;
end
[ResortedData,index] = sort_nat(ResortedDataNew);

for p =1:size(blocs) %seperating peaky slides
    % from the list get the filename in positions of blocks1
    j = blocs(p);
    filename_src =char("D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.1\"+char(ResortedData(j)));
    %EE=dicomread(filename_src);
    filename_dst =char("C:\UOC\ana worktogetermatlab\rara_10-11\src\bottompeaks\"+char(ResortedData(j)));
    % move/copy the .dcm (whose filename is the one selected) to another
    %dicomwrite(EE,filename_dst);
    copyfile(filename_src, filename_dst);
    % folder
  
end
figure
hold on 
plot(inresp_sig3c)
%plot(locs,resp_sig(locs),'rv','MarkerFaceColor','r')
plot(blocs,inresp_sig3c(blocs),'rs','MarkerFaceColor','b')
grid on
xlabel('Projection number');
ylabel('Mean intensity)');
title('Peaks and bottoms of respiratory signal in the whole stack')

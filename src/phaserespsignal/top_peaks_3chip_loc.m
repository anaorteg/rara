clear
close all

load resp_sig3c.mat;

[pks,locs] = findpeaks(resp_sig3c);%find top peak location in respiratory signal in the whole stack
%findpeaks(resp_sig3c); title('peaks in respiratory signal');

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

for p =1:size(locs) %seperating peaky slides
    % from the list get the filename in positions of blocks1
    j = locs(p);
    filename_src =char("D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.1\"+char(ResortedData(j)));
    %EE=dicomread(filename_src);
    filename_dst =char("C:\UOC\ana worktogetermatlab\rara_10-11\src\toppeaks\"+char(ResortedData(j)));
    % move/copy the .dcm (whose filename is the one selected) to another
    %dicomwrite(EE,filename_dst);
    copyfile(filename_src, filename_dst);
    % folder
end


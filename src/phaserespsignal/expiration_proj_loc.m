clear
close all

load resp_sig3c.mat;

expiration_projection_loc= sortPhaseRespSignal(resp_sig3c');


%% Move the dicom files in the projection numbers of
% expiration_projection_location (location =1 means this frame is an expiration)
% into a new folder to prepare it for reconstruction.
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
s=size(expiration_projection_loc);

for p =1:s(2) %seperating expiration phase projections
    % from the list get the filename in positions of expiration phase
    j = expiration_projection_loc(p);
    if j==1
        filename_src =char("D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.1\"+char(ResortedData(p)));
        %EE=dicomread(filename_src);
        filename_dst =char("C:\UOC\ana worktogetermatlab\rara_10-11\src\expiration_phase_projections\"+char(ResortedData(p)));
        % move/copy the .dcm (whose filename is the one selected) to another
        %dicomwrite(EE,filename_dst);
        copyfile(filename_src, filename_dst);
        % folder
    end
end

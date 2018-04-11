clear
close all

load resp_sig3c.mat;
expiration_projection_loc= sortPhaseRespSignalpi2phase(resp_sig3c');


%% Move the dicom files in the projection numbers of
% expiration_projection_location (location =1 means this frame is an expiration)
% into a new folder to prepare it for reconstruction.
srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\1.2.3.1.11.3853.1\*.dcm');
numNames = length(srcfiles);
format long;
if (numNames <= 2)
    error('dcmDir does not contain any files');
end
for k=1:numNames
    ResortedDataNew{k}=srcfiles(k).name;
end
[ResortedData,index] = sort_nat(ResortedDataNew);
s=size(expiration_projection_loc);
dis_proj= zeros(1,16);
mean_dis_proj = zeros(1,16);
max_dis_proj = zeros(1,16);
for p =1:s(2) %seperating expiration phase projections
    % from the list get the filename in positions of expiration phase
    filename_src =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\1.2.3.1.11.3853.1\"+char(ResortedData(p)));
    j = expiration_projection_loc(p);
    switch j
        case 1
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\2phasepi\1exhale\"+char(ResortedData(p)));
        otherwise
            
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\2phasepi\2inhale\"+char(ResortedData(p)));
    end
    if max_dis_proj(j) < dis_proj(j)
        max_dis_proj(j) = dis_proj(j);
    end
    mean_dis_proj(j)= dis_proj(j) + mean_dis_proj(j);
    dis_proj(j)=0;
    dis_proj=dis_proj+1;
    copyfile(filename_src, filename_dst);
end
for fdr = 1:2
    switch fdr
        case 1
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\2phasepi\1exhale\*.dcm');
            num_fr = length(srcfiles);
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\2phasepi\1exhale\statistics.txt','w');
        case 2
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\2phasepi\2inhale\*.dcm');
            num_fr = length(srcfiles);
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\2phasepi\2inhale\statistics.txt','w');
            
    end
    %Statistics:
    % Max angular distance between projections
    max_step = max_dis_proj(1,fdr)*0.5;
    % Mean angular distance between projections
    mean_step = mean_dis_proj(1,fdr)/num_fr*0.5;
    % Number of projections/total number
    num_fr = num_fr/numNames;
    
    fprintf(fileID,'Max angular distance between projections %d degrees\n Mean angular distance between projections %d degrees\n Number of projections/total number %d \n',max_step,mean_step, num_fr);
    fclose(fileID);
end


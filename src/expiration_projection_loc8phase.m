clear
close all

load resp_sig3c.mat;
expiration_projection_loc= sortPhaseRespSignalpi8phase(resp_sig3c');


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
dis_proj= zeros(1,32);
mean_dis_proj = zeros(1,32);
max_dis_proj = zeros(1,32);
for p =1:s(2) %seperating expiration phase projections
    % from the list get the filename in positions of expiration phase
    filename_src =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\1.2.3.1.11.3853.1\"+char(ResortedData(p)));
    j = expiration_projection_loc(p);
    switch j
        case 1
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\1early exhale\"+char(ResortedData(p)));
        case 2
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\2mid exhale\"+char(ResortedData(p)));
            
        case 3
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\3late exhale\"+char(ResortedData(p)));
            
        case 4
                         
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\4peak exhale\"+char(ResortedData(p)));
            
        case 5
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\5early inhale\"+char(ResortedData(p)));
            
        case 6
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\6mid inhale\"+char(ResortedData(p)));
            
        case 7
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\7late inhale\"+char(ResortedData(p)));
            
        otherwise
           
            filename_dst =char("C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\8peak inhale\"+char(ResortedData(p)));
    end
    if max_dis_proj(j) < dis_proj(j)
      max_dis_proj(j) = dis_proj(j);
    end
    mean_dis_proj(j)= dis_proj(j) + mean_dis_proj(j);
    dis_proj(j)=0;
    dis_proj=dis_proj+1;
    copyfile(filename_src, filename_dst);
end
for fdr = 1:8
    switch fdr
        case 1
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\1early exhale\*.dcm');
            num_fr = length(srcfiles);
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\1early exhale\statistics.txt','w');
        case 2
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\2mid exhale\*.dcm');
            num_fr = length(srcfiles);
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\2mid exhale\statistics.txt','w');
            
        case 3
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\3late exhale\*.dcm');
            num_fr = length(srcfiles);
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\3late exhale\statistics.txt','w');
        case 4
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\4peak exhale\*.dcm');
            num_fr = length(srcfiles)/numNames;
            fileID = fopen('C:\UOC\ana worktogetermatlab\rara_10-11\src\PHase selectipn\8phasepi\4peak exhale\statistics.txt','w');
        case 5
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\5early inhale\*.dcm');
            num_fr = length(srcfiles)/numNames;
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\5early inhale\statistics.txt','w');
        case 6
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\6mid inhale\*.dcm');
            num_fr = length(srcfiles);
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\6mid inhale\statistics.txt','w');
        case 7
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\7late inhale\*.dcm');
            num_fr = length(srcfiles)/numNames;
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\7late inhale\statistics.txt','w');
        case 8
            srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\8peak inhale\*.dcm');
            num_fr = length(srcfiles)/numNames;
            fileID = fopen('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\8phasepi\8peak inhale\statistics.txt','w');
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


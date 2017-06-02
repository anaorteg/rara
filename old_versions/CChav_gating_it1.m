function [ path_dest ] = CChav_gating_it1(acqPath,width,height,nos,nop_s,fmt)
%CChav_gating_it1 Sorting
%   Respiratory gating sorting in freeze phase from a ctf acquisition.
% 
% acqPath is the path to the preprocessed images (i.e ending in subvolume0/)
% width is the number of rows per projection
% height is the number of columns per projection
% nos is the number of angular positions
% nop_s is the number of shoots per angular position
% fmt is the image format tipycally 'uint16'
% 

%Author: AOrtega (UC3M)
%Date: 25/05/2017

%% User selection of gating parameteres
% Detector & images sizes
final_dx=width; % useful detector px in x
final_dy=height; % useful detector px in y
px_x = final_dx;
px_y = final_dy;
% Proyections and files
f1 =1; % where to start in the sorting loop
%final_dz =nos; % angular span
nof = nos*nop_s; % total number of files
n_angles_step = nop_s; % number of proyections per angular step
nop_f = 1; % number of proyections per file
% Variables
all_intensities = zeros(nos,n_angles_step);
%error=0;
ct=zeros([px_x,px_y,n_angles_step]);
data_table = zeros([3,nof]);
data_table(1,:) = 0:nof-1;

for file=1:nof
        %fprintf('Processing file %i of %i\n',file,nof)
        % Indexes of acquisition  & calib file update
        step = fix(file/n_angles_step)+1;
        frame= mod(file,n_angles_step);
        if(frame==0)
            %frame = n_angles_stp;
            step = step -1;
        end %if first frame of step
        data_table(2,file)=step;
end
gr_v = data_table(3,:);
id_v = data_table(1,:);
%% Environment configuration
% Creating directories for result
%if ctfFlag
    new_dir ='p1';
    mkdir(acqPath,new_dir);
    aux_path  = [acqPath 'p1'];
    new_dir ='subvolume00';
    mkdir(aux_path,new_dir);
    path_dest = [acqPath 'p1\subvolume00\'];
    % Loading geometric info
    %[proyAngle, offsetX, offsetY, etaCalc,  DSO, DDO, thetaCalc] = loadCalib([acqPath 'detailedCalibrationCTF.txt'],nof);
    
    % Allocating for user region input
    intenROI = Roi_Union(acqPath,px_x,px_y,fmt,nof);
    %tic;
    intenVol=zeros([abs(intenROI(1,2)-intenROI(4,2))+1,abs(intenROI(1,1)-intenROI(2,1))+1,n_angles_step]);
    profile on;
    % Allocating for resulting set (freeze phase)
    empty_mat = zeros([1, nos]);
    int_mat = zeros([2,nos,nop_s]);
    int_repres = zeros([nos,nop_s]);
    lvl_mat = zeros([nos,2]);
    level=zeros(1,2);
    nof_exp=zeros([1, nos]);
    %g=zeros(1);
 %% Process
    %disp('Signal loop: ');
    for file=f1:nof
        %fprintf('Processing file %i of %i\n',file,nof)
        % Indexes of acquisition  & calib file update
        step = fix(file/n_angles_step)+1;
        frame= mod(file,n_angles_step);
        if(frame==0)
            frame = n_angles_step;
            step = step -1;
        end %if first frame of step
        %% ROI to consider
        fname = [acqPath num2str(file-1) '.ct'];
        [ct(:,:,frame),refT] =readSimpleBin(fname,px_x,px_y,nop_f,fmt);
        intenVol(:,:,frame)=ct(intenROI(1,2):intenROI(4,2),intenROI(1,1):intenROI(2,1),frame);
        all_intensities (step,frame) = mean(mean(intenVol(:,:,frame)));
        if(frame ==  n_angles_step)
            group =zeros([1,n_angles_step]); %mask for averaging blocks per step
            a_aux = all_intensities (step,:);
            mn=median(a_aux);
            data = all_intensities(step,:)-mn;
            
            %Checking what happens if i substract the avg img before sorting
            range_s_avg = max(data,[],2)-min(data,[],2);
            
            %% Gating loop
            %Checking what happens if i substract the avg img before sorting
                level(1)=min(data,[],2);
                level(2)=level(1)+1.5/100*range_s_avg; %   1.5 stands for the margin for selecting 2 or more expiration frames
                lvl_mat(step,:)=level;
                index = find(data <= level(2));
                index2 = setdiff(1:numel(data),index);
                if (~isempty(index))
                    group(1,index) = 1;
                    int_mat(1,step,index)=data(index);
                    int_mat(2,step,index2)=data(index2);
                end 
            clearvars index;
            clearvars index2;
           
            idx=find(group(1,:)~= 0); %indexes of the frames belonging to the phase 
            Lidx = length(idx); % number of frames
            nof_exp(step)=Lidx;
            if (~isempty(idx))
                gr_v (data_table(2,:)==step)=group(1,:);
                id_aux = id_v(data_table(2,:)==step);
                for i=1:Lidx
                fd = fopen([path_dest   num2str(id_aux(idx(i))) '.ct'], 'w+');
                fwrite(fd, ct(:,:,idx(i)), fmt);
                fclose(fd);
                end
                int_repres(step,idx) = mean(mean(ct(:,:,idx)));
                
            else % There are no frames representing the phase
                disp(['empty group phase 1' 'step' num2str(step)]);
                empty_mat(1,step) = 1;
            end %if-else
            
            
            level=[];
            ct=[];
        end %if all frames at that step analyzed
    end %for projections nof
    % Debug purpose: save matrix of empty groups
        save([acqPath 'p1\emptyStepsPerPhase.mat'],'empty_mat')
        save([acqPath 'p1\intensitiesPerPhase.mat'],'int_mat')
        save([acqPath 'p1\levelPerStep.mat'],'lvl_mat')
        save([acqPath 'p1\expFramesPerStep.mat'],'nof_exp')
        save([acqPath 'p1\represPerStep.mat'],'int_repres')
profile off;
profile viewer;
end %function

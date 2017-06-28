function [ resp_data_table, card_data_table, brate, hrate, card_path_dest ] = respCardSignal( acqPath,width,height,nos,nop_s,fmt )
% Cardiac and respiratory signals are extracted from the intensities variations from
% Regions of Interest
% A preproccesing of the projections is performed to match the mean
% intensities and then the files are sorted

%Author: NMurty AOrtega (UC3M)
%Date: 28/06/2017

%% User selection of gating parameteres
% Detector & images sizes
final_dx=width; % useful detector px in x
final_dy=height; % useful detector px in y
px_x = final_dx;
px_y = final_dy;

% Projections and files
nof = nos*nop_s; % total number of files
n_angles_step = nop_s; % number of proyections per angular step
nop_f = 1; % number of proyections per file

% Variables
all_intensities = zeros(nos,n_angles_step);

%Resp 
%error=0;
ctf=zeros([px_x,px_y]);
resp_data_table = zeros([3,nof]);
resp_data_table(1,:) = 0:nof-1;

%Card
card_ctf=zeros([px_x,px_y]);
card_data_table = zeros([3,nof]);
card_data_table(1,:) = 0:nof-1;

for file=1:nof
        %fprintf('Processing file %i of %i\n',file,nof)
        % Indexes of acquisition  & calib file update
        step = fix(file/n_angles_step)+1;
        frame= mod(file,n_angles_step);
        if(frame==0)
            %frame = n_angles_stp;
            step = step -1;
        end %if first frame of step
        resp_data_table(2,file)=step;
        card_data_table(2,file)=step;
end

%% Creating directories for result
    %Resp path
    new_dir ='p1';
    mkdir(acqPath,new_dir);
    aux_path  = [acqPath 'p1'];
    new_dir ='subvolume00';
    mkdir(aux_path,new_dir);
    resp_path_dest = [acqPath 'p1\subvolume00\'];
    
    %Card path
    new_dir ='c1';
    mkdir(acqPath,new_dir);
    aux_path  = [acqPath 'c1'];
    new_dir ='subvolume00';
    mkdir(aux_path,new_dir);
    card_path_dest = [acqPath 'c1\subvolume00\'];
    % Loading geometric info
    %[proyAngle, offsetX, offsetY, etaCalc,  DSO, DDO, thetaCalc] = loadCalib([acqPath 'detailedCalibrationCTF.txt'],nof);
    
    % Ask the user to select a ROI based on the 4 cardinal points of the
    % acquisition
    %fprintf('Pick the region of interest to get the breathing rate \n')
    resp_intenROI = RespRoi_Union(acqPath,px_x,px_y,fmt,nof);
    card_intenROI = CardRoi_Union(acqPath,px_x,px_y,fmt,nof);    %tic;
    % Allocating for user region input
    resp_intenVol=zeros([abs(resp_intenROI(1,2)-resp_intenROI(4,2))+1,abs(resp_intenROI(1,1)-resp_intenROI(2,1))+1]);
    card_intenVol=zeros([abs(card_intenROI(1,2)-card_intenROI(4,2))+1,abs(card_intenROI(1,1)-card_intenROI(2,1))+1]);
    
    resp_means= zeros(1,nof);
    card_means= zeros(1,nof);
    %meanstwo = zeros(1,nof);
    %profile on;
    
%%  Process
    %disp('Signal loop: ');
    for file=1:nof
        fprintf('Processing file %i of %i\n',file,nof)
        % Indexes of acquisition  & calib file update
        step = fix(file/n_angles_step)+1;
        frame= mod(file,n_angles_step);
        if(frame==0)
            frame = n_angles_step;
            step = step -1;
        end %if first frame of step
        
        %% Opening a projection and getting the ROI
        fname = [acqPath num2str(file-1) '.ct'];
        [ctf,refT] =readSimpleBin(fname,px_x,px_y,nop_f,fmt);
        
         % Mean match every file
        ctf= mean_match(ctf,  65535/2);
        resp_intenVol=ctf(resp_intenROI(1,2):resp_intenROI(4,2),resp_intenROI(1,1):resp_intenROI(2,1));
        card_intenVol=ctf(card_intenROI(1,2):card_intenROI(4,2),card_intenROI(1,1):card_intenROI(2,1));
        
        %intenVols = maskIm( intenVol,file, path_dest,fmt);
        
        %fd = fopen([path_dest  num2str(file-1) '.ct'], 'w+');
        %fwrite(fd, ct(:,:,frame), fmt);
        %fclose(fd);
        
        %take a mean of the images
        resp_means(file) = mean(mean(resp_intenVol));
        card_means(file) = mean(mean(card_intenVol));
        
        
    end%for NOF  
        resp_means_sm = smooth(resp_means,'rlowess')';
        resp_means = resp_means-resp_means_sm;
        
        card_means_sm = smooth(card_means,'rlowess')';
        card_means = card_means-card_means_sm;

%% Run respSignal and cardSignal

    % resp_means signal for 4112 intensities 
    % card_means signal for 4112 intensities 

    % sort for resp_means and fill resp_data_table
    [resp_data_table, brate] = respSignal(acqPath, resp_path_dest, resp_data_table, resp_means,nof);

    % sort for card_means taking into account resp_data_table 
    % and fill card_data_table         
    [card_data_table, card_path_dest, hrate] = cardSignal(acqPath, card_path_dest,resp_data_table,card_data_table, card_means,nof);
     
end


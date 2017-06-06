function [ path_dest ] = respSignal(acqPath,width,height,nos,nop_s,fmt)
% Respiratory signal extracted from the intensities variations from
% a Region of Interest
% A preproccesing of the projections is performed to match the mean
% intensities

%Author: NMurty AOrtega (UC3M)
%Date: 25/05/2017

%% User selection of gating parameteres
% Detector & images sizes
final_dx=width; % useful detector px in x
final_dy=height; % useful detector px in y
px_x = final_dx;
px_y = final_dy;
% Proyections and files
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

for file=1:200
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
    
    % Ask the user to select a ROI based on the 4 cardinal points of the
    % acquisition
    intenROI = Roi_Union(acqPath,px_x,px_y,fmt,nof);
    %tic;
    % Allocating for user region input
    intenVol=zeros([abs(intenROI(1,2)-intenROI(4,2))+1,abs(intenROI(1,1)-intenROI(2,1))+1,nof]);
    means= zeros(1,nof);
    meanstwo = zeros(1,nof);
    profile on;

 %% Process
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
        [ct(:,:,frame),refT] =readSimpleBin(fname,px_x,px_y,nop_f,fmt);
         % Mean match every file
        ct(:,:,frame)= mean_match(ct(:,:,frame),  65535/2);
        intenVol(:,:,file)=ct(intenROI(1,2):intenROI(4,2),intenROI(1,1):intenROI(2,1),frame);
        %fd = fopen([path_dest  num2str(file-1) '.ct'], 'w+');
        %fwrite(fd, ct(:,:,frame), fmt);
        %fclose(fd);
        means(file) = mean(mean(intenVol(:,:,file)));
        
     
    end%for NOF   

    
     % Find an array of mean intensities
    means_sm = smooth(means,'rlowess')';
    means = means-means_sm;
    %Plot the array
    figure;
    plot(id_v, means);
    
    
    %Find breathing rate of mouse
    breath = zeros(1,nof);
    var = zeros(1,nof);
    count = 0;
    %find number of frames per breath
    for n = 1:nof
            if means(n) > 170
                %for normal peaks
                if n>1 && n < nof
                    if means(n+1)< means(n)&& means(n) > means(n-1) && means(n+1) > -50
                       breath(n)= count;
                       count = 0;
                    end
                end
                
                %for peak at n = 1
                if n==1 && means(n+1)< means(n) && means(n+1) > 0
                   breath(n) = 0;
                end
                
                %for peak at n=nof
                if n==nof && means(n) > means(n-1) && means(n+1) > 0
                   breath(n) = count;
                end
            end
        count = count +1;
    end %for frames of breath
    
    %add time for changing angle
    counts = 0;
    avg = 0;
    for num = 1:nof     
        if breath(num) > 0
           if num > 7
              var(num) = breath(num) - mod(num,8); %used to find the number of times the angle has changed
              var(num)= fix(var(num)/8);
           end
           counts = counts +1;
        end
        breath(num) = (breath(num)*0.05) + var(num);
        avg = avg + breath(num);
    end %for rate
    
    %find average breathing rate
    avg = avg/counts;
    avg = 60/avg;
    fprintf('The average breathing rate is %.2f breaths per minute. Number of breaths taken is %d. \n',avg, counts) 
    
        

end %function

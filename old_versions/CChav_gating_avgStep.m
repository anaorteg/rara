function [ path_dest ] = CChav_gating_avgStep(acqPath,nos,nop_s,bin,fmt)
%CChav_gating_avgStep
%   Respiratory gating sorting for static imaging, post sorting in phases
% acqPath is the path to the preprocessed images (i.e ending in subvolume00/)
% width is the number of rows
% height is the number of columns
% nos is the number of angular positions
% fmt is the image format tipycally 'uint16'

%Author: AOrtega (UC3M)
%Date: 25/05/2017

%% User selection of gating parameteres
% Detector & images sizes
px_x =  3072/bin;
px_y = 1944/bin;
% Proyections and files
f1 =1; % where to start in the sorting loop
nof = nos*nop_s; % total number of files
n_angles_stp = nop_s; % number of proyections per angular stp
nop_f = 1; % number of proyections per file
% Variables
% |file id|step|exp
data_table = zeros([3,nof]);
data_table(1,:) = 0:nof-1;
for file=1:nof
    %fprintf('Processing file %i of %i\n',file,nof)
    % Indexes of acquisition  & calib file update
    step = fix(file/n_angles_stp)+1;
    frame= mod(file,n_angles_stp);
    if(frame==0)
        %frame = n_angles_stp;
        step = step -1;
    end %if first frame of step
    data_table(2,file)=step;
end
% Using the intestities computed in previous it
int_mat = importdata([acqPath 'p1\represPerStep.mat']);
all_intensities = reshape(int_mat.',[1 nos*nop_s]);
nof_exp = importdata([acqPath 'p1\expFramesPerStep.mat']);
nof_exp_prev = nof_exp;
%error=0;



%% Environment configuration
% Creating directories for result
%if ctfFlag
new_dir ='p1_it2';
mkdir(acqPath,new_dir);
aux_path  = [acqPath 'p1_it2'];
new_dir ='subvolume00';
mkdir(aux_path,new_dir);
path_dest = [acqPath 'p1_it2\subvolume00\'];
%tic;
%profile on;
% Allocating for resulting set
level=zeros(1,2);
repres = zeros([px_x,px_y,1]);
%% Process
%disp('Signal loop: ');

%fprintf('Processing file %i of %i\n',file,nof)
% Indexes of acquisition  & calib file update
%% ROI to consider
%% When all intensities from the same stp have been considered, fix the
% phase thresholds
mn=median(all_intensities(all_intensities~=0));
all_int_aux = all_intensities-mn;
% %all_int_aux (all_int_aux == -mn) = 0;
data = all_intensities (all_intensities~=0)-mn;
data_sm = smooth(data,'rlowess')';
% %%%%%%debug%%%%%%
% figure
% subplot(3,1,1)       % add first plot in 2 x 1 grid
% plot(data)
% title('Intensity var signal')
% subplot(3,1,2)       % add second plot in 2 x 1 grid
% plot(data_sm)       % plot using + markers
% title('Smooth signal(source fluctuations)')
% subplot(3,1,3)       % add second plot in 2 x 1 grid
% plot(abs(data -data_sm))       % plot using + markers
% title('Respiratory signal')
% figure
% subplot(3,1,1)       % add first plot in 2 x 1 grid
% plot(data(1:24))
% title('Intensity var signal')
% subplot(3,1,2)       % add second plot in 2 x 1 grid
% plot(data_sm(1:24))       % plot using + markers
% title('Smooth signal(source fluctuations)')
% subplot(3,1,3)       % add second plot in 2 x 1 grid
% plot(abs(data(1:24)-data_sm(1:24)))       % plot using + markers
% title('Respiratory signal')
%%%%%%%%%%%%%%%%%%%%
data= abs(data - data_sm);
all_int_aux(all_int_aux~=-mn)= abs(all_int_aux(all_int_aux~=-mn) - data_sm(1,:));

%% Gating loop
level(1)=min(data,[],2);
range_s_avg = max(data(data<1000),[],2)-level(1);
level(2)=level(1)+7/100*range_s_avg;
%level(2)=max(data);

index = find(all_int_aux <= level(2) & all_int_aux ~=-mn);
if (~isempty(index))
    data_table(3,index)=1;
end %if
profile on;
%data_table(3,:)=1;
angles = [];
clearvars index;
%clearvars index2;
gr = data_table(3,:);
id = data_table(1,:);
id_p = 0;
for st = 1: nos
    st_data = gr(data_table(2,:)==st);
    st_id = id ((data_table(2,:)==st));
    idx=find(st_data ~=0);
    %idx=find(gr_aux(:,st)~= 0)-1; %indexes of the frames belonging to phase k
    Lidx = length(idx); % number of frames
    ct=zeros([px_x,px_y,Lidx]);
    if (~isempty(idx))
        for aux = 1:Lidx
            fname = [acqPath 'p1\subvolume00\' num2str(st_id(idx(aux))) '.ct'];
            [ct(:,:,aux),refT] =readSimpleBin(fname,px_x,px_y,1,fmt);
        end
        repres(:,:,1)=mean(ct,3);
        fd = fopen([path_dest   num2str(id_p) '.ct'], 'w+');
        fwrite(fd, repres(:,:,1), fmt);
        fclose(fd);
        clearvars ct;
        id_p=id_p+1;
        if(~isempty(angles))
            angles = [angles (st-1)*0.7];
        else
            angles = (st-1)*0.7;
        end
        nof_exp(st)=Lidx;
    else
        disp(['empty stp ' num2str(st)]);
    end
end

calibFileGenerator(path_dest,angles,bin);
new_dir ='pavg';
mkdir(acqPath,new_dir);
aux_path  = [acqPath 'pavg'];
new_dir ='subvolume00';
mkdir(aux_path,new_dir);
path_dest = [acqPath 'pavg\subvolume00\'];
data_table(3,:)=1;

%clearvars index2;
gr = data_table(3,:);
id = data_table(1,:);
id_p = 0;
for st = 1: nos
    st_data = gr(data_table(2,:)==st);
    st_id = id ((data_table(2,:)==st));
    idx=find(st_data ~=0);
    %idx=find(gr_aux(:,st)~= 0)-1; %indexes of the frames belonging to phase k
    Lidx = length(idx); % number of frames
    ct=zeros([px_x,px_y,Lidx]);
    if (~isempty(idx))
        for aux = 1:Lidx
            fname = [acqPath num2str(st_id(idx(aux))) '.ct'];
            [ct(:,:,aux),refT] =readSimpleBin(fname,px_x,px_y,1,fmt);
        end
        repres(:,:,1)=mean(ct,3);
        fd = fopen([path_dest   num2str(id_p) '.ct'], 'w+');
        fwrite(fd, repres(:,:,1), fmt);
        fclose(fd);
        clearvars ct;
        id_p=id_p+1;
    end
end

% calibFileGenerator(path_dest,angles,bin);
profile off;
profile viewer;
end %function

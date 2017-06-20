%Corrects the images so they can be analyzed
here = mfilename('fullpath');
[path, ~, ~] = fileparts(here);
addpath(genpath(path));

%% *********************** ACQ Parameters *********************************
% Data paths and files
acqPath = 'D:\nmurty\data\954\20170609T082519\'; %KEEP THE "\"
binning= 4; %Binning of acquisition
nos = 514; %number of steps
n_angles_step = 8; %number of projections per step
n_phases_desired=1;
fmt = 'uint16';

%% ********************** Central body **********************************
%splitter(patient,acqPath , width,height,n_angles_step,nos,fmt);
nof = nos*n_angles_step; % number of files
width =  3072/binning; % 768
height = 1944/binning; % 486
% With '\' at the end
floodFileName = '\\PC-178-154\Users\Public\Documents\NM\flat_field\';
%procPath = [acqPath 'subvolume00\'];
procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);
acqPath = 'D:\nmurty\data\955\20170609T093055\';
procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);
acqPath = 'D:\nmurty\data\956\20170609T094334\';
procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);
acqPath = 'D:\nmurty\data\957\20170609T095640\';
procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);
acqPath = 'D:\nmurty\data\959\20170609T102559\';
procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);
acqPath = 'D:\nmurty\data\960\20170609T104908\';
procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);
acqPath = 'D:\nmurty\data\962\20170609T111641\';
procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);
acqPath = 'D:\nmurty\data\963\20170609T113415\';
procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);

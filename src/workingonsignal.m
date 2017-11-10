%% BEFORE RUNNING SELECT THE NAMES AND PATHS
raw_path='C:\memoey\RECONSTRUCTIONNN\New_preprocessed\'; %ended by \
mod_num = 1; %26/10 Bottom peaks 
<<<<<<< HEAD
beamdata_path = 'D:\1.2.3.2.11.3853\1.2.3.1.11.3853.2';
dst_path = 'D:\ppbottom_peaks\';
=======
beamdata_path = '';
dst_path = 'C:\Users\Aortega\Documents\17_10_MARS\gating\tries\from_new_preproc\';
>>>>>>> 41d2374c488fbce790448f22a344fcf70dddc747
%%


%Extracting the bottom peaks in the first and second camera position and
%saving them in bottom_peaks folder

load C:\Users\Aortega\Documents\17_10_MARS\gating\tries\from_new_preproc\F.mat F;
f_s=size(F);
F = F(126:254,:,:) ;
Zaxisprofile = zeros(1,f_s(3));
%outI = zeros(f_s(1),f_s(2));
%m=65535/2;
%F = F/44000;
dst_path =newSeries(mod_num,beamdata_path,dst_path);


for   j= 1:1243 %1st camera position
     %outI = mean_match(F(:,:,j), m);
    outI = F(:,:,j);
    CMean=mean(outI,1);
    VMean=mean(CMean,2);
    Zaxisprofile(j)=VMean;
end

Zaxisprofile = Zaxisprofile(1 : 1243);
illumination_var = smooth(Zaxisprofile,'rlowess');
illumination_var =  illumination_var';
resp_sig = Zaxisprofile-illumination_var;
figure;plot(illumination_var); title('Illumination_var 1st camera position');xlabel('Projection number');
ylabel('Mean intensity)');
figure;colormap gray;imagesc(outI(:,:,end));



[pks,locs1] = findpeaks(resp_sig);%find peak location in respiratory signal in 1st camer position
%findpeaks(resp_sig); title('peaks in respiratory signal');
 
inresp_sig= -resp_sig; %calculating invers respiratory signal for bottoms

[bpks,blocs1] = findpeaks(inresp_sig);%seperating botton peaks in 1st camera position
%findpeaks(inresp_sig);

 %get the ordered list of the dicoms filenames
 srcfiles = dir(strcat(raw_path,'*.dcm'));
numNames = length(srcfiles);
format long;
if (numNames <= 2)
	error('dcmDir does not contain any files');
end
for k=1:numNames;    
    ResortedDataNew{k}=srcfiles(k).name;    
end
[ResortedData,index] = sort_nat(ResortedDataNew); 

  for p =1:size(blocs1') %seperating peaky slides
      % from the list get the filename in positions of blocks1
      j = blocs1(p);
      filename_src =char(strcat(raw_path,char(ResortedData(j))));
      %EE=dicomread(filename_src);
      filename_dst =char("D:\ppbottom_peaks\"+char(ResortedData(j)));
      % move/copy the .dcm (whose filename is the one selected) to another
      %dicomwrite(EE,filename_dst);
      copyfile(filename_src, filename_dst);
      % folder
  end   
  
figure
hold on 
figure ;plot (resp_sig);title('respoiartory signal in the first camera position');xlabel('projection number (1:1243)');ylabel('difference in amplitude in mean intensity'); grid on
hold on
plot(locs1,resp_sig(locs1),'rv','MarkerFaceColor','r')
plot(blocs1,resp_sig(blocs1),'rs','MarkerFaceColor','b')
grid on
xlabel('Projection number')
ylabel('difference in amplitude in mean intensity)')
title('Peaks and bottoms of respiratory signal in the first camera position')
% profile off
% profile viewer



for  j = 1244 : 2486 %2nd camera position
       %outI = mean_match(F(:,:,j), m);
    outI = F(:,:,j);
    CMean=mean(outI,1);
    VMean=mean(CMean,2);
    Zaxisprofile(j)=VMean;
end

Zaxisprofile = Zaxisprofile(1244 : 2486);
illumination_var = smooth(Zaxisprofile,'rlowess');
illumination_var =  illumination_var';
resp_sig = Zaxisprofile-illumination_var;
figure;plot(illumination_var);title(' illumination_var in 2nd camera position');

figure;colormap gray;imagesc(outI(:,:,end));



[pks,locs2] = findpeaks(resp_sig);%find peak location in respiratory signal in 2nd camer position
%findpeaks(resp_sig); title('peaks in respiratory signal');
 locs2=locs2+ f_s(3)/2;% add previous number of 1st acquistion to make a correct starting point
 
inresp_sig= -resp_sig; %calculating invers respiratory signal for bottoms

[bpks,blocs2] = findpeaks(inresp_sig);%seperating botton peaks in 2nd camera position
blocs2 = blocs2 + f_s(3)/2;
%findpeaks(inresp_sig);
 %get the ordered list of the dicoms filenames
 srcfiles = dir(strcat(raw_path,'*.dcm'));
numNames = length(srcfiles);
format long;
if (numNames <= 2)
	error('dcmDir does not contain any files');
end
for k=1:numNames;    
    ResortedDataNew{k}=srcfiles(k).name;    
end
[ResortedData,index] = sort_nat(ResortedDataNew); 

  for p =1:size(blocs2') %seperating peaky slides
      % from the list get the filename in positions of blocks2
      j = blocs2(p);
      filename_src =char(strcat(raw_path,char(ResortedData(j))));
      EE=dicomread(filename_src);
      filename_dst =char("D:\ppbottom_peaks\"+char(ResortedData(j)));%p+f_s(3)/2)));
      % move/copy the .dcm (whose filename is the one selected) to another
      %dicomwrite(EE,filename_dst);
      copyfile(filename_src, filename_dst);
      % folder
  end     
figure
hold on 
figure ;plot (resp_sig);title('respoiartory signal in the second camera position');xlabel('projection number (1244:2486)');ylabel('difference in amplitude in mean intensity');
plot(locs2-f_s(3)/2,resp_sig(locs2-f_s(3)/2),'rv','MarkerFaceColor','r')
plot(blocs2-f_s(3)/2,resp_sig(blocs2-f_s(3)/2),'rs','MarkerFaceColor','b')
grid on
xlabel('Projection number')
ylabel('Mean intensity)')
title('Peaks and bottoms of respiratory signal in the second camera position')
% profile off
% profile viewer

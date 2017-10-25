load F.mat F;
f_s=size(F);
F = F(126:254,:,:) ;
Zaxisprofile = zeros(1,f_s(3)); 
%outI = zeros(f_s(1),f_s(2));
m=65535/2;
%F = F/44000;


for   j= 1:2486 %whole stack
     %outI = mean_match(F(:,:,j), m);
    outI = F(:,:,j);
    CMean=mean(outI,1);
    VMean=mean(CMean,2);
    Zaxisprofile(j)=VMean;
end

illumination_var = smooth(Zaxisprofile,'rlowess');
illumination_var =  illumination_var';
resp_sig = Zaxisprofile-illumination_var;
figure;plot(illumination_var);
title('Illumination_var in the whole stack');
xlabel('Projection number')
ylabel('Mean intensity)')

figure;colormap gray;imagesc(outI(:,:,end));



[pks,locs] = findpeaks(resp_sig);%find peak location in respiratory signal in the whole stack
%findpeaks(resp_sig); title('peaks in respiratory signal');
 
inresp_sig= -resp_sig; %calculating invers respiratory signal for bottoms

[bpks,blocs] = findpeaks(inresp_sig);%seperating botton peaks in the whole stack
%findpeaks(inresp_sig);
 %get the ordered list of the dicoms filenames
 srcfiles = dir('D:\1.2.3.2.11.3853\1.2.3.1.11.3853.1\*.dcm');
numNames = length(srcfiles);
format long;
if (numNames <= 2)
	error('dcmDir does not contain any files');
end
for k=1:numNames;    
    ResortedDataNew{k}=srcfiles(k).name;    
end
[ResortedData,index] = sort_nat(ResortedDataNew); 

  for p =1:size(blocs') %seperating peaky slides
      % from the list get the filename in positions of blocks1
      j = blocs(p);
      filename_src =char("D:\1.2.3.2.11.3853\1.2.3.1.11.3853.1\"+char(ResortedData(j)));
      EE=dicomread(filename_src);
      filename_dst =char("D:\1.2.3.2.11.3853\whole_stack_bottom_peaks\"+char(ResortedData(j)));
      % move/copy the .dcm (whose filename is the one selected) to another
      dicomwrite(EE,filename_dst);
      %copyfile(EE, filename_dst);
      % folder
  end     
figure
hold on 
plot(resp_sig)
%plot(locs,resp_sig(locs),'rv','MarkerFaceColor','r')
plot(blocs,resp_sig(blocs),'rs','MarkerFaceColor','b')
grid on
xlabel('Projection number');
ylabel('Mean intensity)');
title('Peaks and bottoms of respiratory signal in the whole stack')
% profile off
% profile viewer
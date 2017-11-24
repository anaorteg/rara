clear
close all
%extracting the respiratory signal from center of masses in the first
%camera position

load F.mat;
f_s=size(F);
F_orig = F;
noc = 3; %number of chip
Zaxisprofile_orig = zeros(1,f_s(3));
resp_sig = zeros(f_s(3),noc);
chiploc =zeros(f_s(3),1) ;
RC_orig=zeros(f_s(3),1);
resp_sig3c=zeros(f_s(3),1);
for chip =1:3
    if chip==1
        F = F_orig(1:126,:,:) ;%first chip
    elseif chip==2
        F = F_orig(127:254,:,:) ;%second chip
    else
        F = F_orig(255:382,:,:) ;%third chip
    end
    %% Getting the Z-axis-profile for the whole scan
    for   j= 1:f_s(3)
        % Compute the mean pixel value on the chip of interest in the j
        % projection
        CMean=mean(F(:,:,j),1);
        VMean=mean(CMean,2);
        Zaxisprofile_orig(j)=VMean;  % array saving the mean value per projection
%          if j==171
%              fprintf('STOP')
%          end
        % Find the row of the most black point  per projection
        if chip==1
            Pf = F_orig(:,:,j);
            sumf=sum(Pf,2);    %summation pf in the colum
            %cent=centerOfMass(sumf); %finding the centers of mass in each colum
            %center(j)=cent(1);
            %RC=round(center(j));
            [min_v, min_loc] = min(sumf);
            RC = min_loc(1);
            RC_orig(j)=RC;
            % Select the chip of interest
            % For the first projection (j=1) we initialized our chipvalue
            % with the original mapping (ch1 RC<=126 ch2 126<RC<=254
            % ch3 254<RC
            
            % For the next projections and to avoid the oscillations cause
            % by RC moving around the boundaries of a chip, we consider a
            % safety band (+-10 rows) in which the chip location is going
            % to follow the trend of the chip location of the previous
            % projection
            if  RC<126-10 %first chip
                chiploc(j)=1;
            elseif RC>=126-10 &&   RC <=126+10
                if j==1 && RC<127
                    chiploc(j)=1;
                elseif j==1 && RC>=127
                    chiploc(j)=2;
                else
                    chiploc(j)=chiploc(j-1);
                end
            elseif  RC>=126+10 &&   RC<=254-10 %second chip
                chiploc(j)=2;
            elseif RC>=254-10 &&   RC <=254+10
                if j==1 && RC<255
                    chiploc(j)=2;
                elseif j==1 && RC>=255
                    chiploc(j)=3;
                else
                    chiploc(j)=chiploc(j-1);
                end
            else  %third chip: RC=>254+10
                
                chiploc(j)=3;
                
                
            end % if-else chip selection
        end % if we are in the 1st iteration, get the chips per projection
    end % for loop for the projections
    
    %% Start analizing each camera position separately
    
    %dst_path =newSeries(mod_num,beamdata_path,dst_path);
        
    Zaxisprofile = Zaxisprofile_orig(1 : 1243);
    illumination_var = smooth(Zaxisprofile,'rlowess');
    illumination_var =  illumination_var';
    resp_sig(1:1243 ,chip) = Zaxisprofile-illumination_var;
    
    
    %second camera position
    %extracting the respiratory signal from the centers of the mass
    
    Zaxisprofile = Zaxisprofile_orig(1244: 2486);
    illumination_var = smooth(Zaxisprofile,'rlowess');
    illumination_var =  illumination_var';
    resp_sig(1244: 2486,chip) = Zaxisprofile-illumination_var;
    figure;plot(resp_sig); title(['respiratory signal chip ', int2str(chip)]);xlabel('Projection number');
    ylabel('Pixel value difference due to respiratory motion)');
end

for     projection= 1:f_s(3)
    wheremymouseis = chiploc(projection);
    resp_sig3c(projection) = resp_sig(projection,wheremymouseis);
end
% figure;plot(resp_sig3c); title(['respiratory signal whole stcak ']);xlabel('Projection number');
% ylabel('Pixel value difference due to respiratory motion)');
%save resp_sig3c.mat resp_sig3c;


% [pks,locs] = findpeaks(resp_sig3c);%find peak location in respiratory signal in the whole stack
% %findpeaks(resp_sig3c); title('peaks in respiratory signal');

inresp_sig3c= -resp_sig3c;%calculating invers respiratory signal for bottoms
inresp_sig3c=inresp_sig3c+1;
[bpks_org,blocs_org] = findpeaks(inresp_sig3c);%seperating botton peaks in the whole stack

[bpks1,blocs1]= findpeaks(inresp_sig3c(1:880));
M1=mean(bpks1);
std1=std(bpks1);
ldis1=M1-std1/1.5;
udis1=M1+std1/1.5;
s1=size(bpks1);
Blocs1=zeros(s1);
Bpks1=zeros(s1);
for i=1:s1(1)
    if bpks1(i,1)>= ldis1 && bpks1(i,1)<= udis1 %finding peaks with having limitation with std
        Blocs1(i)=blocs1(i);
        Bpks1(i)=bpks1(i);
       
    end
end
Bpks1(Bpks1==0)=[];
Blocs1(Blocs1==0)=[];

[bpks2,blocs2] = findpeaks(inresp_sig3c(881:1386));
blocs2=blocs2+880;
M2=mean(bpks2);
std2=std(bpks2);
ldis2=M2-std2/1.5;
udis2=M2+std2/1.5;
s2=size(bpks2);
Blocs2=zeros(s2);
Bpks2=zeros(s2);
for i=1:s2(1)
    if bpks2(i,1)>= ldis2 && bpks2(i,1)<= udis2 %finding peaks with having limitation with std
        Blocs2(i)=blocs2(i);
        Bpks2(i)=bpks2(i);
       
    end
end
Bpks2(Bpks2==0)=[];
Blocs2(Blocs2==0)=[];



[bpks3,blocs3] = findpeaks(inresp_sig3c(1387:2010));
blocs3=blocs3+1386;
M3=mean(bpks3);
std3=std(bpks3);
ldis3=M3-std3/1.5;
udis3=M3+std3/1.5;
s3=size(bpks3);
Blocs3=zeros(s3);
Bpks3=zeros(s3);

for i=1:s3(1)
    if bpks3(i,1)>= ldis3 && bpks3(i,1)<= udis3 %finding peaks with having limitation with std
        Blocs3(i)=blocs3(i);
        Bpks3(i)=bpks3(i);
       
    end
end
Bpks3(Bpks3==0)=[];
Blocs3(Blocs3==0)=[];




[bpks4,blocs4] = findpeaks(inresp_sig3c(2011:2486));
blocs4=blocs4+2010;
M4=mean(bpks4);
std4=std(bpks4);
ldis4=M4-std4/1.5;
udis4=M4+std4/1.5;
s4=size(bpks4);
Blocs4=zeros(s4);
Bpks4=zeros(s4);

for i=1:s4(1)
    if bpks4(i,1)>= ldis4 && bpks4(i,1)<= udis4 %finding peaks with having limitation with std
        Blocs4(i)=blocs4(i);
        Bpks4(i)=bpks4(i);
       
    end
end
Bpks4(Bpks4==0)=[];
Blocs4(Blocs4==0)=[];

blocs=[Blocs1;Blocs2;Blocs3;Blocs4];
    
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

for p =1:size(blocs) %seperating peaky slides
    % from the list get the filename in positions of blocks1
    j = blocs(p);
    filename_src =char("D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.1\"+char(ResortedData(j)));
    %EE=dicomread(filename_src);
    filename_dst =char("C:\UOC\ana worktogetermatlab\rara_10-11\src\bottompeaks\"+char(ResortedData(j)));
    % move/copy the .dcm (whose filename is the one selected) to another
    %dicomwrite(EE,filename_dst);
    copyfile(filename_src, filename_dst);
    % folder
  
end

figure
hold on 
plot(inresp_sig3c)
%plot(locs,resp_sig(locs),'rv','MarkerFaceColor','r')
plot(blocs,inresp_sig3c(blocs),'rs','MarkerFaceColor','b')
grid on
xlabel('Projection number');
ylabel('Pixel value difference due to respiratory motion');
title('Peaks and bottoms of respiratory signal in the whole stack')

% figure; hold on ;plot(inresp_sig3c(1:880))
% plot(blocs1,inresp_sig3c(blocs1),'g',blocs1,M1,'b--o',blocs1,M1+std1,'c*')

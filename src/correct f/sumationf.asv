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
    resp_sig(1 : 1243,chip) = Zaxisprofile-illumination_var;
    
    
    %%second camera position
    %%extracting the respiratory signal from the centers of the mass
    
    Zaxisprofile = Zaxisprofile_orig(1244: 2486);
    illumination_var = smooth(Zaxisprofile,'rlowess');
    illumination_var =  illumination_var';
    resp_sig(1244: 2486,chip) = Zaxisprofile-illumination_var;
    figure;plot(resp_sig); title(['respiratory signal chip ', int2str(chip)]);xlabel('Projection number');
    ylabel('Pixel value difference due to respiratory motion)');
end

for  projection= 1:f_s(3)
    wheremymouseis = chiploc(projection);
    resp_sig3c(projection) = resp_sig(projection,wheremymouseis);
end
figure;plot(resp_sig3c); title(['respiratory signal combining chips ']);xlabel('Projection number');
ylabel('Pixel value difference due to respiratory motion)');
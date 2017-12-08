profile on
load F.mat F;

f_s=size(F);

Zaxisprofile = zeros(1,f_s(3)); 
%outI = zeros(f_s(1),f_s(2));
m=65535/2;
%F = F/44000;
for j = 1 : f_s(3)
    %outI = mean_match(F(:,:,j), m);
    outI = F(:,:,j);
    CMean=mean(outI,1);
    VMean=mean(CMean,2);
    Zaxisprofile(j)=VMean;
end
illumination_var = smooth(Zaxisprofile,'rlowess');

illumination_var =  illumination_var';
figure;plot(illumination_var); title('illumination variation in whole stack');
resp_sig = Zaxisprofile-illumination_var;
figure;plot(resp_sig); title('respiratory signal from whole stack');
%figure;plot(illumination_var) 
%figure;colormap gray;imagesc(outI(:,:,end))
%profile off
profile viewer

%% 

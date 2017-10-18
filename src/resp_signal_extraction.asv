load D:\1.2.3.2.11.3853\F.mat F;
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
resp_sig = Zaxisprofile-illumination_var;
%figure;plot(illumination_var) 
figure;colormap gray;imagesc(outI(:,:,end))


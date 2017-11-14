load F.mat F;
f_s=size(F);
Zaxisprofile = zeros(1,f_s(3)); 
parfor j = 1 : f_s(3)
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

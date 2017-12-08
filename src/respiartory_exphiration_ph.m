profile on
load FEX.mat FEX;
load stack_index.mat stack_index

f_s=size(FEX);

Zaxisprofile = zeros(1,f_s(3)); 
%outI = zeros(f_s(1),f_s(2));
m=65535/2;
%F = F/44000;
for j = 1 : f_s(3)
    %outI = mean_match(F(:,:,j), m);
    outI = FEX(:,:,j);
    CMean=mean(outI,1);
    VMean=mean(CMean,2);
    Zaxisprofile(j)=VMean;
end
illumination_var = smooth(Zaxisprofile,'rlowess');
illumination_var =  illumination_var';
resp_sigex = Zaxisprofile-illumination_var;
resp_sig_orig_stack= zeros(1,2486);
resp_sig_orig_stack(stack_index)=resp_sigex;
figure;plot(resp_sig_orig_stack); title('respiratory signal from expiration phase2 in two bins');
%figure;plot(illumination_var); title('illumination variation in expiration phase');
%figure;colormap gray;imagesc(outI(:,:,end))
profile off
profile viewer


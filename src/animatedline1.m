load F.mat;

h = animatedline;
% s=size(blocs);
%x = 1:f_s(3);
x=580:600;
y = resp_sig3c(x,1);
mov = implay(F(:,:,x),1);
a = tic; % start timer
b =0;
for k = 1:length(x)
    addpoints(h,k,y(k));
    while b<1
        b = toc(a); % check timer
    end
        drawnow  % update screen every 1/30 seconds
        a = tic; % reset timer after updating
        b = 0;
end


grid on
xlabel('Projection number');
ylabel('Pixel value difference due to respiratory motion');
title(' respiratory signal extracted from  selected projections')
drawnow % draw final frame


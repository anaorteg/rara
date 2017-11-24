h = animatedline;
% s=size(blocs);
x = blocs(:,1);
y = inresp_sig3c(blocs);
a = tic; % start timer
for k = 1:length(x)
    addpoints(h,x(k),y(k))
    b = toc(a); % check timer
    if b >1/1000000
        
        drawnow  % update screen every 1/30 seconds
        a = tic; % reset timer after updating
    end
end
grid on
xlabel('Projection number');
ylabel('Pixel value difference due to respiratory motion');
title(' respiratory signal extracted from  selected projections')
drawnow % draw final frame
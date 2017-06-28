function [ unionROI ] = Roi_Union( acqPath,px_x,px_y,fmt,nof)
%ROI_UNION Roi picker
%   It  returns a retangle that covers the union of rois from the stack
%   quartiles.
intenROI=zeros([4,2,4]);
unionROI = zeros([4,2]);
img = zeros ([px_x,px_y,1]);

for i = 1:4
    index = (i-1)*nof/4;
    fname = [acqPath num2str(index) '.ct'];
    while exist (fname) == 0
        index = index +1;
        fname = [acqPath num2str(index) '.ct'];
    end
   
        [img_aux,refT] =readSimpleBin(fname,px_x,px_y,1,fmt);
    
    keepon=1;
    % Roi selection per opened image
    while(keepon==1)
        %code
        %figure;colormap gray;imagesc(img(:,:,1));axis image;colorbar();title('Choose region of interest')
        figure;colormap gray;imagesc(img_aux(:,:,1));axis image;colorbar();title('Choose heart region of interest')
        p=floor(ginput(2));
        
        intenROI(1,:,i)=[p(1,1),p(1,2)];
        intenROI(2,:,i)=[p(2,1),p(1,2)];
        intenROI(3,:,i)=[p(2,1),p(2,2)];
        intenROI(4,:,i)=[p(1,1),p(2,2)];
        % Showing the selection as a squared roi in the image
        Wsquare=[intenROI(:,:,i);intenROI(1,:,i)];
        hold on
        line(Wsquare(:,1),Wsquare(:,2))
        scatter(intenROI(:,1,i),intenROI(:,2,i))
        % BW = roipoly(imagesc(volume(:,:,1)));
        % Give the option to correct the selection
        prompt='Choose again ROI? y/n\n';
        str = input(prompt,'s');
        if str~='y'
            keepon=0;
        end
        close
    end
    img = img_aux;
end
% Computing the union of the 4 rois
unionROI(1,:)=[min(min(intenROI(:,1,:),[],3)),min(min(intenROI(:,2,:),[],3))];
unionROI(2,:)=[max(max(intenROI(:,1,:),[],3)),min(min(intenROI(:,2,:),[],3))];
unionROI(3,:)=[max(max(intenROI(:,1,:),[],3)),max(max(intenROI(:,2,:),[],3))];
unionROI(4,:)=[min(min(intenROI(:,1,:),[],3)),max(max(intenROI(:,2,:),[],3))];
% Showing the selection as a squared roi in the image
figure;colormap gray;imagesc(img(:,:,1));axis image;colorbar();title('ROI')
Wsquare=[unionROI;unionROI(1,:)];
hold on
line(Wsquare(:,1),Wsquare(:,2))
scatter(unionROI(:,1),unionROI(:,2))
% Wsquare=[unionROI(:,:);unionROI(1,:)];
%  figure;colormap gray;imagesc(img_aux(:,:,1));axis image;colorbar();title('Choose region of interest')
%     hold on
%     line(Wsquare(:,1),Wsquare(:,2))
%     scatter(unionROI(:,1),unionROI(:,2))
end


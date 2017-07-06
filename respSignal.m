function [data_table , average] = respSignal(acqPath,path_dest, data_table, means,nof)
% Respiratory signal extracted from the intensities variations from
% a Region of Interest
% Sorts out any "breathing" images out from a set of ct scans so that the
% reconstruction shows a still diaphram

%Author: NMurty AOrtega (UC3M)
%Date: 25/05/2017

id_v = data_table(1,:);


    
%Plot the array
figure;
plot(id_v, means);
hline = refline([0 150]);
hline.Color = 'r';
    
%% Process    
    %Find breathing rate of mouse
    breath = zeros(1,nof);
    var = zeros(1,nof);
    count = 0;
    avg = zeros(1,nof);
    %find number of frames per breath
    for n = 1:nof
            if n>1 && n < nof 
                if means(n) > 100 + means(n-1)
                    if means(n+1)< means(n)&& means(n) > means(n-1) && means(n+1) > -50
                       breath(n)= count;
                       count = 0;
                       count = count +1;
                       data_table(3,n) = 2;
                       if n>7 % get average breathing rate
                           var(n) = breath(n) - mod(n,8); %used to find the number of times the angle has changed
                           var(n)= fix(var(n)/8);
                           breath(n) = (breath(n)*0.05) + var(n);
                           avg(n) = breath(n);
                       else
                           var(n)= fix(var(n)/8);
                           breath(n) = (breath(n)*0.05) + var(n);
                           avg(n) = breath(n);                           
                       end

                    end
                end
             
            
            %for peak at n = 1
            elseif n==1 && means(n+1)< means(n) && means(n+1) > 0
               breath(n) = 0;
               data_table(3,n) = 2;
            

            %for peak at n=nof
            elseif n==nof && means(n) > means(n-1)
               breath(n) = count;
               data_table(3,n) = 2;
               if n>7 % get average breathing rate
                   var(n) = breath(n) - mod(n,8); %used to find the number of times the angle has changed
                   var(n)= fix(var(n)/8);
                   breath(n) = (breath(n)*0.05) + var(n);
                   avg(n) = breath(n);
               end                
            end
            
            %save files that dont have breathing
            if n>1 && n<nof && means(n) < 150
                    if abs(means(n)-means(n-1))<50 && means(n) - means(n+1)>-50
                        data_table(3,n) = 1 ;
                        copyfile ([acqPath num2str(n-1) '.ct'],path_dest);
                        fprintf('Saving heartbeat file %i\n',n)
                    end
                
            else
               data_table(3,n) = 0 ; 
            end
        
        count = count +1;
    end %for frames of breath
    

%% Find average breathing rate
    avg(avg==0) = [];
    avg(isnan(avg))= [];
    average = mean(avg);
    average = 60/average;
 
    
save([acqPath 'p1\data_table.mat'],'data_table')
        
end %function

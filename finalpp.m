vid = VideoReader('video5.mp4');
data = read(vid,[1900 2400]); % [startframe endframe]. I tried many combination of random numbers 
%since it took too long time if the end frame is to big.  
%Also, I don't exactly know the FPS of MATLAB 

figure
cen_x = []; % Initialize vector to store the x-coordinates of ball
cen_y = []; % Intialize vectot to store the y-coordinates of ball
ballcoord = zeros(501,2);
kk = zeros(720,1280,501);
for k = 1:501    % Loop 801 times as Number of frames captures = 801 this time.
      my_max=0.0;
      diff_max=0.0;
      ele=0;
      diff=zeros(720,1280);

    
    Im = ycbcr2rgb(data(:,:,:,k)); %Convert the kth frame to RGB format 
    Imorg = Im; % Backup the RGB image
    Im = rgb2gray(Im);
    Im = im2double(Im);
    %Im = Im> 0.9; % Threshold
    
    hold on

    %Detecting moving objects(Get abs diffrence from current frame to previous frame)
kk(:,:,k) = Im;
if k>1
          diff=abs(kk(:,:,k)-kk(:,:,k-1));
          thresh = 0.1; %FIgured the best threshold value 0.1 by trying experiments with diffrent kinds of values
 
    if(diff < thresh)
        Im=0;
    end
end
    % Set threshold - extract only white or white-gray color
    Im=Im>0.9;
    
     %Labelling
    [Label,total] = bwlabel(Im,4); % Indexing segments by
                                          % binary label function
      Un=unique(Label);

     %Remove components that is big of too small to be a ball
     for i=1:total
         if(sum(sum(Label==i)) > 250 )|(sum(sum(Label==i)) < 10 )
          Label(Label==i)=0;
 
          end
     end
 


    %Find the properties of the image
        numRegions = max(Label(:)); % Number of distinct regions (ideally 1)
    
    if (numRegions > 0) % If number of regions is greater than zero (i.e. atleast 1 object is detected)

     Sdata = regionprops(Label,'all');

           %Check the Roundness metrics
            %Roundness=4*pi*Area/Perimeter.^2
%      for i=3:numel(Un)
%          Roundness=(4*pi*Sdata(Un(i)).Area)/Sdata(Un(i)).Perimeter.^2;
%          my_max=max(my_max,Roundness);
%          if(Roundness==my_max)
%                  ele=Un(i);
%          end
%      end

          %Find the centroid
       cen=Sdata.Centroid;
       cen_x(k) = cen(1); % Store x - coordinate of the center
       cen_y(k) = cen(2); % Store y - coordinate of the center
    else
            
        cen_x(k) = cen_x(k-1); % If ball not detected, keep previous value
        cen_y(k) = cen_y(k-1);
    end

       %Store the coordinates of ball location
       ballcoord(k,1) = cen_x(k);
       ballcoord(k,2) = cen_y(k);
    

       plot (cen(1),cen(2),'*'); % Plot the centre of the subplot of the image
       hold off
    
    
end
 
 



figure;
imshow(Imorg)
whitebg([0 0 0])
hold on;
plot(cen_x,cen_y,'b.-','LineWidth',5); % Plot the measured values
title('Position estimation results');
xlabel('X - Coordinates');
ylabel('Y - Coordinates');
legend('Measured Trajectory of the Ball');
% The x y coordinates of the ball is stored in ballcoord.
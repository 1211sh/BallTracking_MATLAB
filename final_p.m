clc % Clear command window 
 % Close all open windows
clear all;
%vid=videoinput('winvideo',1,'YUY2_640x480'); %Video input object
vid = VideoReader('video5.mp4');
%start(vid) % Start video
%data = getdata(vid,[1 10]); % Get 10 frames from live video feed
%delete(vid); % Delete video object
data = read(vid,[500 900]);

figure
centres_x = []; % Initialize vector to store the x-coordinates of ball
centres_y = []; % Intialize vectot to store the y-coordinates of ball
 ballcord = zeros(401,2)
for k = 1:401    % Loop 10 times as Number of frames captures = 10
    Im = ycbcr2rgb(data(:,:,:,k)); %Convert the kth frame to RGB format 
    Imorg = Im; % Backup the RGB image
    
    
    % Segmentaion Started
    for i = 1:size(Im,1)       % Loop through the rows of image
        for j = 1:size(Im,2)   % Loop through the cols of image
            if (Im(i,j,1) < 200 && Im(i,j,2) < 200 && Im(i,j,3) < 200) % Remove all parts of image containing shades of gray and white, keep only distinct colors
                Im(i,j,1) = 0;
                Im(i,j,2) = 0;
                Im(i,j,3) = 0;
            end
        end
    end
 
    %figure 
    %subplot(2,5,k) % plot original image in a subplot window
    %imshow(Imorg);   
    hold on
    
    Im = im2double(Im); % Convert image to double
    imR = squeeze(Im(:,:,1)); % Extract the red part of image
    imBinaryR = im2bw(imR,graythresh(imR)); %Convert red part to binary
    imBinaryR = bwareaopen(imBinaryR,20); % Remove areas less than 20 pixels
    imBinaryR = imfill(imBinaryR,'holes'); % Remove holes in the binary image
 
    [B,L] = bwboundaries(imBinaryR,'noholes'); % Extract the distinct regions in the image
    numRegions = max(L(:)) % Number of distinct regions (ideally 1)
    
    if (numRegions > 0) % If number of regions is greater than zero (i.e. atleast 1 object is detected)
        stats = regionprops(L,'all'); % Get stats for the objects in the image
        centre = stats.Centroid; % Get the struct for centre of the ball
        centres_x(k) = centre(1); % Store x - coordinate of the center
        centres_y(k) = centre(2); % Store y - coordinate of the center
    else
        centres_x(k) = centres_x(k-1); % If ball not detected, keep previous value
        centres_y(k) = centres_y(k-1);
    end
    
    plot (centre(1),centre(2),'*'); % Plot the centre of the subplot of the image
    hold off
    
    ballcord(k,1) = centres_x(k) 
    ballcord(k,2) = centres_y(k)
end
 
 
 
figure;
imshow(Imorg)
whitebg([0 0 0])
hold on;
plot(centres_x,centres_y,'g.-','LineWidth',5); % Plot the measured values
title('Position estimation results');
xlabel('X - Coordinates');
ylabel('Y - Coordinates');
legend('Measured Trajectory of the Ball');

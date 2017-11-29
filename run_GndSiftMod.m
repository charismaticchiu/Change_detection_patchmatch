%% System starts here
close all;
clear all;
tic;
%initialize variables
% havematched_num = [];
% matchedCoef = [];   %All the scores of the 1st matched 
% matchedCoef2 = [];  %All the scores of the 2nd matched

% fileID = fopen('output.txt','a+');
videoptr = fopen('video/final_videos_240_b43d_goodlabel_2.txt','r'); % pointer to videonames.txt

videos = textscan(videoptr,'%s'); %paths of videos
videos = videos{1};
fclose(videoptr);
for i = 13 : length(videos)       % when encountering 'i', it means we are analyzing the i-th video
%  i = 1; %run the first video for now
    labelpath = strcat('video/saved_labels/label_',videos(i),'.txt');
    labelptr = fopen(labelpath{1});
    labels = textscan(labelptr,'%s%s');
    
    temp = [];
    for j = 1:size(labels,2)
        temp = [temp labels{j}];
    end

    %% assign image relative paths
   
    for j = 1:size(temp,1)               
        for k = 1:size(temp,2) 
            if ~strcmp(temp{j,k},'')
                images{j,k} = strcat('./video/', videos(i), '/patchmatch_thres/', temp{j,k}, '.jpg');
            end
        end
    end
    %% crop the image
%     iterationNum = [3,10,20];
%     for iter = iterationNum
%         for j = 1: size(images,1) % number of panos
%             for k = 2: size(images,2) % number of dash Cam frames            
%                 if  ~strcmp(images{j,k},'')% If there is a frame for this index k, then do find_ann0  
% 
%                     [matched, maxCoef, maxCoef2]= find_ann0(images{j,1},images{j,k} ,iter, i, j *size(images,2) + k );
%                     if matched
%                         matchedCoef = [matchedCoef maxCoef];
%                         matchedCoef2 = [matchedCoef2 maxCoef2];
%                       
%                     end
%                 end
%             end
%         end
%     end
    %% do patch match 
    
%     for iter = 4:1:10
    iter = 4;
    videoName = cell2mat(videos(i));
    for j=1:size(images,1)
        imageName(j) = images{j,2};
    end
    
    for j = 1:size(images,1) % number of panos        
        
        panoName = cell2mat(images{j,1});
        frameName = cell2mat(imageName(j));
        frameNum = str2double(frameName(end-8:end-4));
        if(frameNum < 8 )
            frameNumM1 = strcat(frameName(1:end-5),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-5),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-5),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-5),num2str(frameNum+2),'.jpg');
        elseif(frameNum == 8 )
            frameNumM1 = strcat(frameName(1:end-5),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-5),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-5),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-6),num2str(frameNum+2),'.jpg');
        elseif (frameNum == 9 || frameNum == 10)
            frameNumM1 = strcat(frameName(1:end-5),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-5),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-6),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-6),num2str(frameNum+2),'.jpg');                
        elseif (frameNum == 11)
            frameNumM1 = strcat(frameName(1:end-6),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-5),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-6),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-6),num2str(frameNum+2),'.jpg');
        elseif (frameNum >11 && frameNum < 98)
            frameNumM1 = strcat(frameName(1:end-6),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-6),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-6),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-6),num2str(frameNum+2),'.jpg');
        elseif (frameNum == 98)
            frameNumM1 = strcat(frameName(1:end-6),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-6),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-6),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-7),num2str(frameNum+2),'.jpg');
        elseif (frameNum == 99 || frameNum == 100)
            frameNumM1 = strcat(frameName(1:end-6),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-6),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-7),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-7),num2str(frameNum+2),'.jpg');
        elseif (frameNum == 101)
            frameNumM1 = strcat(frameName(1:end-7),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-6),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-7),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-7),num2str(frameNum+2),'.jpg');
        elseif (frameNum > 101)
            frameNumM1 = strcat(frameName(1:end-7),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-7),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-7),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-7),num2str(frameNum+2),'.jpg');
        end
                
        for thre = 160:20:200
            for boxRatio = 0.5:0.1:1.5    
                if exist(frameNumM1,'file') == 2
                    [~]= changeDetectAconBsiftMod(panoName,frameNumM1, videoName, j * 5 + 1, iter,boxRatio,thre);
                elseif exist(frameNumM2,'file') == 2
                    [~]= changeDetectAconBsiftMod(panoName,frameNumM2, videoName, j * 5 + 2, iter,boxRatio,thre);
                elseif exist(frameNumP1,'file') == 2
                    [~]= changeDetectAconBsiftMod(panoName,frameNumP1, videoName, j * 5 + 3, iter,boxRatio,thre);
                elseif exist(frameNumP2,'file') == 2
                    [~]= changeDetectAconBsiftMod(panoName,frameNumP2, videoName, j * 5 + 4, iter,boxRatio,thre);
                end
                [~]= changeDetectAconBsiftMod(panoName, frameName, videoName, j * 5 + 5, iter,boxRatio,thre);
            end
        end             
    end
    fclose(labelptr);
end   



close all;
disp(['Time for pricessing crops for a video: ', num2str(toc), ' sec']);

% ratioptr = fopen('./video/1/ratio.txt','w+'); % record ratio
% fprintf(ratioptr,num2str([matchedCoef',matchedCoef2',ratio']));
%xlswrite('./video/1/ratio.xlsx',mat);
 
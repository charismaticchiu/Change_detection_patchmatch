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
for i = 22 : length(videos)       % when encountering 'i', it means we are analyzing the i-th video
%  i = 1; %run the first video for now
    labelpath = strcat('video/saved_labels/label_',videos(i),'.txt');
    labelptr = fopen(labelpath{1});
    labels = textscan(labelptr,'%s%s');
    
    temp = [];
    for j = 1:size(labels,2)
        temp = [temp labels{j}];
    end

    %% assign image relative paths
    images = {};
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
        elseif (frameNum > 101 && frameNum < 1000)
            frameNumM1 = strcat(frameName(1:end-7),num2str(frameNum-1),'.jpg');
            frameNumM2 = strcat(frameName(1:end-7),num2str(frameNum-2),'.jpg');
            frameNumP1 = strcat(frameName(1:end-7),num2str(frameNum+1),'.jpg');
            frameNumP2 = strcat(frameName(1:end-7),num2str(frameNum+2),'.jpg');
        else continue; % Ignore the cases that frameNumber greater than 1000
        end
                
        for thre = 160:40:240
            for boxRatio = 0.5:0.25:1.5    
                n = boxRatio/0.25 -1;
                if exist(frameNumM1,'file') == 2
                    [M1sc1(n),M1sc2(n),M1sc3(n)]= changeDetectAconBsiftModLAB(panoName,frameNumM1, videoName, j * 5 + 1, iter,boxRatio,thre);
                end
                if exist(frameNumM2,'file') == 2
                    [M2sc1(n),M2sc2(n),M2sc3(n)]= changeDetectAconBsiftModLAB(panoName,frameNumM2, videoName, j * 5 + 2, iter,boxRatio,thre);
                end
                if exist(frameNumP1,'file') == 2
                    [P1sc1(n),P1sc2(n),P1sc3(n)]= changeDetectAconBsiftModLAB(panoName,frameNumP1, videoName, j * 5 + 3, iter,boxRatio,thre);
                end
                if exist(frameNumP2,'file') == 2
                    [P2sc1(n),P2sc2(n),P2sc3(n)]= changeDetectAconBsiftModLAB(panoName,frameNumP2, videoName, j * 5 + 4, iter,boxRatio,thre);
                end
                [Csc1(n),Csc2(n),Csc3(n)]= changeDetectAconBsiftModLAB(panoName, frameName, videoName, j * 5 + 5, iter,boxRatio,thre);
                
            end
            
            dir = strcat('./video/',videoName,'/LAB/Modulated/sift/withResizePatchMatch/Thre',num2str(thre));
           
            plot([Csc1', Csc2', Csc3']);
            print(strcat(dir, frameName(strfind(frameName,'image')-1:end-4),'_score_',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
            
            if exist(frameNumM1,'file') == 2
                plot([M1sc1', M1sc2', M1sc3']);
                print(strcat(dir, frameNumM1(strfind(frameNumM1,'image')-1:end-4),'_score_',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
            end
            if exist(frameNumM2,'file') == 2
                plot([M2sc1', M2sc2', M2sc3']);
                print(strcat(dir, frameNumM2(strfind(frameNumM2,'image')-1:end-4),'_score_',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
            end
            if exist(frameNumP1,'file') == 2
                plot([P1sc1', P1sc2', P1sc3']);
                print(strcat(dir, frameNumP1(strfind(frameNumP1,'image')-1:end-4),'_score_',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
            end
            if exist(frameNumP2,'file') == 2
                plot([P2sc1', P2sc2', P2sc3']);
                print(strcat(dir, frameNumP2(strfind(frameNumP2,'image')-1:end-4),'_score_',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
            end
        end
    end
    
    fclose(labelptr);
end   



close all;
disp(['Time for pricessing crops for a video: ', num2str(toc), ' sec']);

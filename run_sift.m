%% System starts here
close all;
clear all;
tic;
%initialize variables
% havematched_num = [];
% matchedCoef = [];   %All the scores of the 1st matched 
% matchedCoef2 = [];  %All the scores of the 2nd matched

% fileID = fopen('output.txt','a+');
videoptr = fopen('videonames.txt','r'); % pointer to videonames.txt
videos = textscan(videoptr,'%s'); %paths of videos
videos = videos{1};
% for i = 1 : length(videos)       % when encountering 'i', it means we are analyzing the i-th video
 i = 2; %run the first video for now
    imgpath = 'video/2/similar.txt';
    imgpathptr = fopen(imgpath,'r');
    images = textscan(imgpathptr,'%s%s%s%s%s%s');%images: filepaths of images
    temp = [];
    for j = 1:size(images,2)
        temp = [temp images{j}];
    end
    images = temp;
    %% assign image relative paths
    for j = 1:size(images,1)               
        for k = 1:size(images,2) 
            if ~strcmp(images{j,k},'')
                images{j,k} = ['./' videos{i} '/' images{j,k} '.jpg'];
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
    
    for j = 1: size(images,1) % number of panos
        for k = 2: size(images,2) % number of dash Cam frames  
            score{j}{k} = [];
            if  ~strcmp(images{j,k},'')% If there is a frame for this index k, then do find_ann0 
                for thre = 100:20:200
                    for boxRatio = 0.5:0.05:1.5     
%                         disp(['haha']);
                        [sc1,sc2,sc3]= changeDetectAconBsift(images{j,1},images{j,k} , i, j  *size(images,2) + k , iter,boxRatio,thre);
                        score{j}{k} = [score{j}{k};sc1,sc2,sc3];
                    end
                    figure;
                    plot( score{j}{k} );
                    dir = ['./video/',num2str(i),'/noModulated/sift/withoutResizePatchMatch/Thre',num2str(thre),'/'];
                    saveas(gcf ,[dir,images{j,1}(11:end-4),'__',images{j,k}(11:end)]);
                    dlmwrite([dir,images{j,1}(11:end-4),'__',images{j,k}(11:end-4),'.txt'],score{j}{k},'precision','%.3f');
                end
            end
        end
    end
    

fclose(videoptr);
close all;
disp(['Time for pricessing crops for a video: ', num2str(toc), ' sec']);
ratio = matchedCoef2./matchedCoef;
% ratioptr = fopen('./video/1/ratio.txt','w+'); % record ratio
% fprintf(ratioptr,num2str([matchedCoef',matchedCoef2',ratio']));
%xlswrite('./video/1/ratio.xlsx',mat);
%% Stage 2: patch match
%Under construction
% 
% cropedptr = fopen(['./video/','1','/output','1','.txt'],'r'); % pointer to videonames.txt
% cropped_dash = textscan(cropedptr,'%s%s'); %paths of cropped image and corresponding dash image
% for i=0:size(cropped_dash,1)
%     find_unmatchedArea(cropped_dash{1}{i}, cropped_dash{2}{i});
% end
%  
%% System starts here
close all;
clear all;
tic;
%initialize variables
havematched_num = [];
matchedCoef = [];   %All the scores of the 1st matched 
matchedCoef2 = [];  %All the scores of the 2nd matched
imgpathptr = 0.0;


% fileID = fopen('output.txt','a+');
videoptr = fopen('videonames.txt','r'); % pointer to videonames.txt
videos = textscan(videoptr,'%s'); %paths of videos
videos = videos{1};
% for i = 1 : length(videos)       % when encountering 'i', it means we are analyzing the i-th video
for i =2:2 %run the first video for now
    imgpath = [videos{i} '/filenames.txt'];
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
    
    for iter = 0:2:10
        for boxRatio = 1:0.5:4
            for j = 1: size(images,1) % number of panos
                for k = 2: size(images,2) % number of dash Cam frames            
                    if  ~strcmp(images{j,k},'')% If there is a frame for this index k, then do find_ann0  
                        find_unmatchedAreaBconA(images{j,1},images{j,k} , i, j  *size(images,2) + k , iter,boxRatio);
                        find_unmatchedAreaAconB(images{j,1},images{j,k} , i, j  *size(images,2) + k , iter,boxRatio);
        %                 [matched, maxCoef, maxCoef2]= find_ann0(images{j,1},images{j,k} , i, j *size(images,2) + k );
        %                 if matched
        %                     matchedCoef = [matchedCoef maxCoef];
        %                     matchedCoef2 = [matchedCoef2 maxCoef2];
        %                   
        %                 end
                    end
                end
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
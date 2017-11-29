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
for i = 1 : length(videos{1})       % when encountering 'i', it means we are analyzing the i-th video
    
    imgpaths{1}{i} = [videos{1}{i} '/filenames.txt'];
    imgpathptr = fopen(imgpaths{1}{i},'r');
    images = textscan(imgpathptr,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');%images: filepaths of images
    %% assign image relative paths
    for j = 1:length(images{1})        
        images{1}{j} = ['./' videos{1}{i} '/' 'pano_' images{1}{j} '_180.jpg'];
    end
    for k = 2: length(images)% k means column; start from 2 is becuz the first column is the name of pano
        for j = 1:length(images{1})% j means row
            if ~strcmp(images{k}{j},'')
                images{k}{j} = ['./' videos{1}{i} '/' images{k}{j} '.jpg'];
            end
        end
    end
    %% crop the image
    for j = 1: length(images{1}) % number of panos
        for k = 2: length(images) % number of dash Cam frames
            
            if  ~strcmp(images{k}{j},'')% If there is a frame for this index k, then do find_ann0                
                [matched, maxCoef, maxCoef2]= find_ann0(images{1}{j},images{k}{j},i );
                if matched
                    matchedCoef = [matchedCoef maxCoef];
                    matchedCoef2 = [matchedCoef2 maxCoef2];
                    disp(['Croped pano: ' images{1}{j} '; counterpart dash cam image: ' images{k}{j} ]);
                    %havematched_num = [havematched_num k];
%                     break; %Add 'break' to only find the first matched
%                     dashCam frame in the list
                end
            end
            
        end
        
        images{1}{j} = [images{1}{j}(1:end-7) '0' images{1}{j}(end-3:end)]; % run 0 degree pano the process again
        for k = 2: length(images) % number of dash frames
            if  ~strcmp(images{k}{j},'') %&& ~ismember(k,havematched_num)%% not necessarily the matched is correct, so do it again for all images for now
                [matched, maxCoef, maxCoef2] = find_ann0(images{1}{j},images{k}{j},i );
                if matched
                    matchedCoef = [matchedCoef maxCoef];
                    matchedCoef2 = [matchedCoef2 maxCoef2];
                    disp(['Cropped pano: ' images{1}{j} '; counterpart dash cam image: ' images{k}{j} ]);
%                     break;
                end
            end
        end
    end
    
    
    
end
fclose(videoptr);
close all;
disp(['Time for pricessing crops for a video: ', num2str(toc), ' sec']);
ratio = matchedCoef2./matchedCoef;
ratioptr = fopen('./video/1/ratio.txt','w+'); % record ratio
fprintf(ratioptr,num2str([matchedCoef',matchedCoef2',ratio']));
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
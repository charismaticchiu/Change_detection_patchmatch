% videoptr = fopen('video/final_videos_240_b43d_goodlabel_2.txt','r'); % pointer to videonames.txt
videoptr = fopen('video/undone.txt','r'); 
videos = textscan(videoptr,'%s'); %paths of videos
videos = videos{1};
fclose(videoptr);
labeledCount = 0;
allLabeledPat = {};
firstFile=68; % if want to label new videos, start from this one
tempFile = 38;
% for i = firstFile : length(videos) 
% for i = tempFile :tempFile
for i = 1:length(videos) 
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
    
    for j = 1:size(images,1) % number of panos
        panoName = cell2mat(images{j,1});
        frameName = cell2mat(images{j,2});
        panoH = figure('Position',[50 300 900 500]);        
        imPano = imread(panoName);
        imagesc(imPano);
        disp('========================================================')
        disp(['PANO and FRAME:   Labeled Count: ', num2str(labeledCount)])
        disp(panoName)
        disp(frameName)
        
        frameH = figure('Position',[1000 300 900 500]); 
        imFrame = imread(frameName);
        imagesc(imFrame);
        k = waitforbuttonpress;
        while  k ~= 1
            k = waitforbuttonpress;
        end
        if ~strcmp(get(frameH,'currentcharacter'),'q')
            disp('----------Start Labeling-----------')
            m = 1;
            pos = {};
            while true   
                disp(['----------',num2str(m),' Label-----------'])
                h = imrect;
                p = wait(h);
                pos{m} = getPosition(h);
                q = waitforbuttonpress;
                while  q ~= 1
                    q = waitforbuttonpress;
                end
                if strcmp(get(frameH,'currentcharacter'),'e')
                    break
                end
                m = m + 1;
            end
            images{j,4} = pos;
            images{j,3} = m;
            labeledCount = labeledCount + 1;
            for k = 1:4
                allLabeledPat{labeledCount,k} = images{j,k};
            end
        else
            disp(['----------No Label For This Pair-----------'])
            images{j,3} = 0;
        end
        close(panoH)
        close(frameH)        
    end
    dir = strcat('./video/', videos(i), '/patchmatch_thres/');    
    save(cell2mat(strcat(dir,'positions.mat')),'images');
    fclose(labelptr);
    if labeledCount >= 50 && labeledCount < 100
        disp('--- Thank You ---')
        disp('--- Let"s switch---')
%     elseif labeledCount >= 1
%         break;
    end
    save(strcat('./video/','allLabeledPat.mat'),'allLabeledPat');
end
disp('End of Labeling ------ Thank YOU!!')
save(strcat('./video/','allLabeledPat.mat'),'allLabeledPat');


%% System starts here
close all;
clear all;
tic;
load('./video/allLabeled.mat');
    %% do patch match     
%     for iter = 4:1:10
iter = 4;
ransacThre = 200;
boxRatio = 1;
performanceRecord = allLabeled;
patchNum = 6;
for j = 1:size(allLabeled,1) % number of panos      

    panoName = cell2mat(allLabeled{j,1});
    frameName = cell2mat(allLabeled{j,2});
    numOfLabels = allLabeled{j,3};
    labeledPositions = allLabeled{j,4};
%     performanceRecord{j,5} = table(ones(1,7)',ones(1,7)',ones(1,7)','VariableNames',{'win_size100';'win_size150';'win_size200'},...
%         'RowNames',{'boxR1' 'boxR2' 'boxR3' 'boxR4' 'boxR5' 'boxR6' 'boxR7'});
    performanceRecord{j,5} = [];
    p = 0;
    for patch_w = 1:3:7
        p = p + 1;
        q = 0;
        for boxRatio = 1:1:7
            q = q + 1;
            r = 0;
            for win_size = 100:50:300
                r = r + 1;
                [xmin,ymin,wid,len]= changeDetectAconBrgbSiftlabModrgbPMCalc(panoName, frameName, ...
                        11 , iter,boxRatio,ransacThre,labeledPositions,patch_w, win_size);
                close 11
                overlapThre = 0.3;
                ratio = ones(numOfLabels,patchNum);

                for i = 1:numOfLabels
                    for k = 1:patchNum
                        overlapArea = rectint([xmin(k),ymin(k),wid(k),len(k)],labeledPositions{i});
                        ratio(i,k) = overlapArea/(labeledPositions{i}(3) * labeledPositions{i}(4) + wid(k) * len(k) - overlapArea);            
                    end
                end

                %%%%%%
                precision = [];
                recall = [];
                for usedPatchNum = 1:patchNum
                    ratioCalc = ratio;

                    hit = 0;
                    for i = 1:usedPatchNum
                        [val, idx] = max(ratioCalc(:,i));
                        if val >= overlapThre
                            hit = hit +1; 
                            ratioCalc(idx,:) = -1;
                        end

                    end
                    precision(usedPatchNum) = hit/usedPatchNum;
                    recall(usedPatchNum) = hit/numOfLabels;
                end

                dir = strcat('./video/Label/rgbSiftlabModrgbPM/ransacThre',...
                    num2str(ransacThre),'AconsBiter',num2str(iter),'/boxR',num2str(boxRatio),'winSize',num2str(win_size),'patchW',num2str(patch_w));
                figure(5);
                plot( recall, precision );
                ylabel('Precision','FontSize',12);
                xlabel('Recall','FontSize',12);
                print(strcat(dir,'/PR__' ,frameName(strfind(frameName,'image'):end-4),'__',...
                    panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
                close 5
                area = 0;
                %%%%%%%
                for i = 1:usedPatchNum-1
                    area = area + (precision(i) + precision(i+1)) *  (recall(i+1) - recall(i) ) / 2;
                end
                performanceRecord{j,5}{p,q,r} = area;
            end
                %%%%%%%
            
        end
    end
    
%     allLabeled{j,5} = area;
%     dir = strcat('./video/Labeled/LAB/Modulated/sift/withResizePatchMatch/ransacThre',num2str(ransacThre));
%     figure; 
%     subplot(221); plot([Csc1', Csc2', Csc3']);
%     panoFig = imread(panoName);
%     subplot(222); imagesc(panoFig);
%     frameFig = imread(frameName);
%     subplot(224); imagesc(frameFig);
%     print(strcat(dir,'/Score__' ,frameName(strfind(frameName,'image'):end-4),'__',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
%     
    
end
changeDetectAconBrgbSiftlabModrgbPM = performanceRecord;
save(strcat('./video/Label/','changeDetectAconBrgbSiftlabModrgbPM.mat'),'changeDetectAconBrgbSiftlabModrgbPM');

%%2changeDetectAconBrgbSiftnoModlabPMCalc
for j = 1:size(allLabeled,1) % number of panos      

    panoName = cell2mat(allLabeled{j,1});
    frameName = cell2mat(allLabeled{j,2});
    numOfLabels = allLabeled{j,3};
    labeledPositions = allLabeled{j,4};
%     performanceRecord{j,5} = table(ones(1,7)',ones(1,7)',ones(1,7)','VariableNames',{'win_size100';'win_size150';'win_size200'},...
%         'RowNames',{'boxR1' 'boxR2' 'boxR3' 'boxR4' 'boxR5' 'boxR6' 'boxR7'});
    performanceRecord{j,5} = [];
    p = 0;
    for patch_w = 1:3:7
        p = p + 1;
        q = 0;
        for boxRatio = 1:1:7
            q = q + 1;
            r = 0;
            for win_size = 100:50:300
                r = r + 1;
                [xmin,ymin,wid,len]= changeDetectAconBrgbSiftnoModlabPMCalc(panoName, frameName, ...
                        11 , iter,boxRatio,ransacThre,labeledPositions,patch_w, win_size);
                close 11
                overlapThre = 0.3;
                ratio = ones(numOfLabels,patchNum);

                for i = 1:numOfLabels
                    for k = 1:patchNum
                        overlapArea = rectint([xmin(k),ymin(k),wid(k),len(k)],labeledPositions{i});
                        ratio(i,k) = overlapArea/(labeledPositions{i}(3) * labeledPositions{i}(4) + wid(k) * len(k) - overlapArea);            
                    end
                end

                %%%%%%
                precision = [];
                recall = [];
                for usedPatchNum = 1:patchNum
                    ratioCalc = ratio;

                    hit = 0;
                    for i = 1:usedPatchNum
                        [val, idx] = max(ratioCalc(:,i));
                        if val >= overlapThre
                            hit = hit +1; 
                            ratioCalc(idx,:) = -1;
                        end

                    end
                    precision(usedPatchNum) = hit/usedPatchNum;
                    recall(usedPatchNum) = hit/numOfLabels;
                end

                dir = strcat('./video/Label/rgbSiftnoModlabPM/ransacThre',...
                    num2str(ransacThre),'AconsBiter',num2str(iter),'/boxR',num2str(boxRatio),'winSize',num2str(win_size),'patchW',num2str(patch_w));
                figure(5);
                plot( recall, precision );
                ylabel('Precision','FontSize',12);
                xlabel('Recall','FontSize',12);
                print(strcat(dir,'/PR__' ,frameName(strfind(frameName,'image'):end-4),'__',...
                    panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
                close 5
                area = 0;
                %%%%%%%
                for i = 1:usedPatchNum-1
                    area = area + (precision(i) + precision(i+1)) *  (recall(i+1) - recall(i) ) / 2;
                end
                performanceRecord{j,5}{p,q,r} = area;
            end
                %%%%%%%
            
        end
    end
    
%     allLabeled{j,5} = area;
%     dir = strcat('./video/Labeled/LAB/Modulated/sift/withResizePatchMatch/ransacThre',num2str(ransacThre));
%     figure; 
%     subplot(221); plot([Csc1', Csc2', Csc3']);
%     panoFig = imread(panoName);
%     subplot(222); imagesc(panoFig);
%     frameFig = imread(frameName);
%     subplot(224); imagesc(frameFig);
%     print(strcat(dir,'/Score__' ,frameName(strfind(frameName,'image'):end-4),'__',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
%     
    
end
changeDetectAconBrgbSiftnoModlabPM = performanceRecord;
save(strcat('./video/Label/','changeDetectAconBrgbSiftnoModlabPM.mat'),'changeDetectAconBrgbSiftnoModlabPM');


%%3changeDetectAconBrgbSiftnoModrgbPMCalc
for j = 1:size(allLabeled,1) % number of panos      

    panoName = cell2mat(allLabeled{j,1});
    frameName = cell2mat(allLabeled{j,2});
    numOfLabels = allLabeled{j,3};
    labeledPositions = allLabeled{j,4};
%     performanceRecord{j,5} = table(ones(1,7)',ones(1,7)',ones(1,7)','VariableNames',{'win_size100';'win_size150';'win_size200'},...
%         'RowNames',{'boxR1' 'boxR2' 'boxR3' 'boxR4' 'boxR5' 'boxR6' 'boxR7'});
    performanceRecord{j,5} = [];
    p = 0;
    for patch_w = 1:3:7
        p = p + 1;
        q = 0;
        for boxRatio = 1:1:7
            q = q + 1;
            r = 0;
            for win_size = 100:50:300
                r = r + 1;
                [xmin,ymin,wid,len]= changeDetectAconBrgbSiftnoModrgbPMCalc(panoName, frameName, ...
                        11 , iter,boxRatio,ransacThre,labeledPositions,patch_w, win_size);
                close 11
                overlapThre = 0.3;
                ratio = ones(numOfLabels,patchNum);

                for i = 1:numOfLabels
                    for k = 1:patchNum
                        overlapArea = rectint([xmin(k),ymin(k),wid(k),len(k)],labeledPositions{i});
                        ratio(i,k) = overlapArea/(labeledPositions{i}(3) * labeledPositions{i}(4) + wid(k) * len(k) - overlapArea);            
                    end
                end

                %%%%%%
                precision = [];
                recall = [];
                for usedPatchNum = 1:patchNum
                    ratioCalc = ratio;

                    hit = 0;
                    for i = 1:usedPatchNum
                        [val, idx] = max(ratioCalc(:,i));
                        if val >= overlapThre
                            hit = hit +1; 
                            ratioCalc(idx,:) = -1;
                        end

                    end
                    precision(usedPatchNum) = hit/usedPatchNum;
                    recall(usedPatchNum) = hit/numOfLabels;
                end

                dir = strcat('./video/Label/rgbSiftnoModrgbPM/ransacThre',...
                    num2str(ransacThre),'AconsBiter',num2str(iter),'/boxR',num2str(boxRatio),'winSize',num2str(win_size),'patchW',num2str(patch_w));
                figure(5);
                plot( recall, precision );
                ylabel('Precision','FontSize',12);
                xlabel('Recall','FontSize',12);
                print(strcat(dir,'/PR__' ,frameName(strfind(frameName,'image'):end-4),'__',...
                    panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
                close 5
                area = 0;
                %%%%%%%
                for i = 1:usedPatchNum-1
                    area = area + (precision(i) + precision(i+1)) *  (recall(i+1) - recall(i) ) / 2;
                end
                performanceRecord{j,5}{p,q,r} = area;
            end
                %%%%%%%
            
        end
    end
    
%     allLabeled{j,5} = area;
%     dir = strcat('./video/Labeled/LAB/Modulated/sift/withResizePatchMatch/ransacThre',num2str(ransacThre));
%     figure; 
%     subplot(221); plot([Csc1', Csc2', Csc3']);
%     panoFig = imread(panoName);
%     subplot(222); imagesc(panoFig);
%     frameFig = imread(frameName);
%     subplot(224); imagesc(frameFig);
%     print(strcat(dir,'/Score__' ,frameName(strfind(frameName,'image'):end-4),'__',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
%     
    
end
changeDetectAconBrgbSiftnoModrgbPM = performanceRecord;
save(strcat('./video/Label/','changeDetectAconBrgbSiftnoModrgbPM.mat'),'changeDetectAconBrgbSiftnoModrgbPM');


%%4changeDetectAconBrgbSiftrgbModlabPMCalc
for j = 1:size(allLabeled,1) % number of panos      

    panoName = cell2mat(allLabeled{j,1});
    frameName = cell2mat(allLabeled{j,2});
    numOfLabels = allLabeled{j,3};
    labeledPositions = allLabeled{j,4};
%     performanceRecord{j,5} = table(ones(1,7)',ones(1,7)',ones(1,7)','VariableNames',{'win_size100';'win_size150';'win_size200'},...
%         'RowNames',{'boxR1' 'boxR2' 'boxR3' 'boxR4' 'boxR5' 'boxR6' 'boxR7'});
    performanceRecord{j,5} = [];
    p = 0;
    for patch_w = 1:3:7
        p = p + 1;
        q = 0;
        for boxRatio = 1:1:7
            q = q + 1;
            r = 0;
            for win_size = 100:50:300
                r = r + 1;
                [xmin,ymin,wid,len]= changeDetectAconBrgbSiftrgbModlabPMCalc(panoName, frameName, ...
                        11 , iter,boxRatio,ransacThre,labeledPositions,patch_w, win_size);
                close 11
                overlapThre = 0.3;
                ratio = ones(numOfLabels,patchNum);

                for i = 1:numOfLabels
                    for k = 1:patchNum
                        overlapArea = rectint([xmin(k),ymin(k),wid(k),len(k)],labeledPositions{i});
                        ratio(i,k) = overlapArea/(labeledPositions{i}(3) * labeledPositions{i}(4) + wid(k) * len(k) - overlapArea);            
                    end
                end

                %%%%%%
                precision = [];
                recall = [];
                for usedPatchNum = 1:patchNum
                    ratioCalc = ratio;

                    hit = 0;
                    for i = 1:usedPatchNum
                        [val, idx] = max(ratioCalc(:,i));
                        if val >= overlapThre
                            hit = hit +1; 
                            ratioCalc(idx,:) = -1;
                        end

                    end
                    precision(usedPatchNum) = hit/usedPatchNum;
                    recall(usedPatchNum) = hit/numOfLabels;
                end

                dir = strcat('./video/Label/rgbSiftrgbModlabPM/ransacThre',...
                    num2str(ransacThre),'AconsBiter',num2str(iter),'/boxR',num2str(boxRatio),'winSize',num2str(win_size),'patchW',num2str(patch_w));
                figure(5);
                plot( recall, precision );
                ylabel('Precision','FontSize',12);
                xlabel('Recall','FontSize',12);
                print(strcat(dir,'/PR__' ,frameName(strfind(frameName,'image'):end-4),'__',...
                    panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
                close 5
                area = 0;
                %%%%%%%
                for i = 1:usedPatchNum-1
                    area = area + (precision(i) + precision(i+1)) *  (recall(i+1) - recall(i) ) / 2;
                end
                performanceRecord{j,5}{p,q,r} = area;
            end
                %%%%%%%
            
        end
    end
    
%     allLabeled{j,5} = area;
%     dir = strcat('./video/Labeled/LAB/Modulated/sift/withResizePatchMatch/ransacThre',num2str(ransacThre));
%     figure; 
%     subplot(221); plot([Csc1', Csc2', Csc3']);
%     panoFig = imread(panoName);
%     subplot(222); imagesc(panoFig);
%     frameFig = imread(frameName);
%     subplot(224); imagesc(frameFig);
%     print(strcat(dir,'/Score__' ,frameName(strfind(frameName,'image'):end-4),'__',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
%     
    
end
changeDetectAconBrgbSiftrgbModlabPM = performanceRecord;
save(strcat('./video/Label/','changeDetectAconBrgbSiftrgbModlabPM.mat'),'changeDetectAconBrgbSiftrgbModlabPM');



%%5changeDetectAconBrgbSiftrgbModrgbPMCalc
for j = 1:size(allLabeled,1) % number of panos      

    panoName = cell2mat(allLabeled{j,1});
    frameName = cell2mat(allLabeled{j,2});
    numOfLabels = allLabeled{j,3};
    labeledPositions = allLabeled{j,4};
%     performanceRecord{j,5} = table(ones(1,7)',ones(1,7)',ones(1,7)','VariableNames',{'win_size100';'win_size150';'win_size200'},...
%         'RowNames',{'boxR1' 'boxR2' 'boxR3' 'boxR4' 'boxR5' 'boxR6' 'boxR7'});
    performanceRecord{j,5} = [];
    p = 0;
    for patch_w = 1:3:7
        p = p + 1;
        q = 0;
        for boxRatio = 1:1:7
            q = q + 1;
            r = 0;
            for win_size = 100:50:300
                r = r + 1;
                [xmin,ymin,wid,len]= changeDetectAconBrgbSiftrgbModrgbPMCalc(panoName, frameName, ...
                        11 , iter,boxRatio,ransacThre,labeledPositions,patch_w, win_size);
                close 11
                overlapThre = 0.3;
                ratio = ones(numOfLabels,patchNum);

                for i = 1:numOfLabels
                    for k = 1:patchNum
                        overlapArea = rectint([xmin(k),ymin(k),wid(k),len(k)],labeledPositions{i});
                        ratio(i,k) = overlapArea/(labeledPositions{i}(3) * labeledPositions{i}(4) + wid(k) * len(k) - overlapArea);            
                    end
                end

                %%%%%%
                precision = [];
                recall = [];
                for usedPatchNum = 1:patchNum
                    ratioCalc = ratio;

                    hit = 0;
                    for i = 1:usedPatchNum
                        [val, idx] = max(ratioCalc(:,i));
                        if val >= overlapThre
                            hit = hit +1; 
                            ratioCalc(idx,:) = -1;
                        end

                    end
                    precision(usedPatchNum) = hit/usedPatchNum;
                    recall(usedPatchNum) = hit/numOfLabels;
                end

                dir = strcat('./video/Label/rgbSiftrgbModrgbPM/ransacThre',...
                    num2str(ransacThre),'AconsBiter',num2str(iter),'/boxR',num2str(boxRatio),'winSize',num2str(win_size),'patchW',num2str(patch_w));
                figure(5);
                plot( recall, precision );
                ylabel('Precision','FontSize',12);
                xlabel('Recall','FontSize',12);
                print(strcat(dir,'/PR__' ,frameName(strfind(frameName,'image'):end-4),'__',...
                    panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
                close 5
                area = 0;
                %%%%%%%
                for i = 1:usedPatchNum-1
                    area = area + (precision(i) + precision(i+1)) *  (recall(i+1) - recall(i) ) / 2;
                end
                performanceRecord{j,5}{p,q,r} = area;
            end
                %%%%%%%
            
        end
    end
    
%     allLabeled{j,5} = area;
%     dir = strcat('./video/Labeled/LAB/Modulated/sift/withResizePatchMatch/ransacThre',num2str(ransacThre));
%     figure; 
%     subplot(221); plot([Csc1', Csc2', Csc3']);
%     panoFig = imread(panoName);
%     subplot(222); imagesc(panoFig);
%     frameFig = imread(frameName);
%     subplot(224); imagesc(frameFig);
%     print(strcat(dir,'/Score__' ,frameName(strfind(frameName,'image'):end-4),'__',panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
%     
    
end
changeDetectAconBrgbSiftrgbModrgbPM = performanceRecord;
save(strcat('./video/Label/','changeDetectAconBrgbSiftrgbModrgbPM.mat'),'changeDetectAconBrgbSiftrgbModrgbPM');

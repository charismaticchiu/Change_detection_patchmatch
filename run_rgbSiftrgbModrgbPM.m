tic;
% load('./video/allLabeled.mat');
load('./video/newLabeled.mat');
    %% do patch match     
%     for iter = 4:1:10
iter = 4;
ransacThre = 200;
boxRatio = 1;
% performanceRecord = allLabeled;
performanceRecord = newLabeled;
patchNum = 5;
% for j = 1:size(allLabeled,1) % number of panos      
for j = 1:size(newLabeled,1) % number of panos    
%     panoName = cell2mat(allLabeled{j,1});
    panoName = cell2mat(newLabeled{j,1});
%     frameName = cell2mat(allLabeled{j,2});
    frameName = cell2mat(newLabeled{j,2});
%     numOfLabels = allLabeled{j,3};
    numOfLabels = newLabeled{j,3};
%     labeledPositions = allLabeled{j,4};
    labeledPositions = newLabeled{j,4};
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
                precision = zeros(1,patchNum);
                recall = zeros(1,patchNum);
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
                
                area = 0;
                if recall(1) ~= 0
                    precision = [max(precision),precision];
                    recall = [0,recall];
                    for i = 1:size(precision,2)
                        precision(i) = max(precision(i:end));
                    end
                    for i = 1:size(precision,2)-1
                        area = area + (precision(i) + precision(i+1)) *  (recall(i+1) - recall(i) ) / 2;
                    end
                else
                    for i = 1:size(precision,2)
                        precision(i) = max(precision(i:end));
                    end
                    for i = 1:usedPatchNum-1
                        area = area + (precision(i) + precision(i+1)) *  (recall(i+1) - recall(i) ) / 2;
                    end
                end
                performanceRecord{j,5}(p,q,r) = area;
%                 figure(5);
%                 plot( recall, precision );
%                 title(['AP: ',num2str(area)]);                
%                 xlim([0 1.5])
%                 ylim([0 1.5])
%                 ylabel('Precision','FontSize',12);
%                 xlabel('Recall','FontSize',12);
% 
%                 dir = strcat('./video/Label/rgbSiftrgbModrgbPM/ransacThre',...
%                     num2str(ransacThre),'AconsBiter',num2str(iter),'/boxR',num2str(boxRatio),'winSize',num2str(win_size),'patchW',num2str(patch_w));                
%                 
%                 print(strcat(dir,'/PR__' ,frameName(strfind(frameName,'image'):end-4),'__',...
%                     panoName(strfind(panoName,'pano'):end-4)),'-dpng','-r250');
%                 close 5  
                
                for i = 1:size(xmin,2)
                    performanceRecord{j,6}{p,q,r}{i} = [xmin(i),ymin(i),wid(i),len(i)];
                end
            end       
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
   
    changeDetectAconBrgbSiftrgbModrgbPM = performanceRecord;
    save(strcat('./video/Label/','changeDetectAconBrgbSiftrgbModrgbPM.mat'),'changeDetectAconBrgbSiftrgbModrgbPM');

end

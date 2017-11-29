
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

    performanceRecord{j,5} = [];
    p = 0;
%     p = 1;
    
%     for patch_w = 1:3:7
    patch_w = 7;
        p = p + 1;
        q = 0;
        for boxRatio = 0:1:15
            q = q + 1;
            r = 0;
%             r = 1;
            for win_size = 100:50:300
%             win_size = 200;
                r = r + 1;
                [area,xmin,ymin,wid,len]= changeDetectAconBrgbSiftlabModrgbPMCalcPrc(panoName, frameName, ...
                        11 , iter,boxRatio,ransacThre,labeledPositions,patch_w, win_size);
                close 11

                performanceRecord{j,5}(p,q,r) = area;
      
                for i = 1:size(xmin,2)
                    performanceRecord{j,6}{p,q,r}{i} = [xmin(i),ymin(i),wid(i),len(i)];
                end
            end
        end
%     end
  
    changeDetectAconBrgbSiftlabModrgbPMPrc7 = performanceRecord;
    save(strcat('./video/Label/','changeDetectAconBrgbSiftlabModrgbPMPrc7.mat'),'changeDetectAconBrgbSiftlabModrgbPMPrc7');
end
toc
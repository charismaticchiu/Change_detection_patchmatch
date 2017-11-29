tic;
load('./video/allLabeled.mat');
    %% do patch match     
%     for iter = 4:1:10
iter = 4;
ransacThre = 200;

performanceRecord = allLabeled;
patchNum = 5;
patch_w = 1;
boxRatio = 2;
win_size = 100;
Area = zeros(2,size(allLabeled,1));
for j = 1:size(allLabeled,1) % number of panos      

    panoName = cell2mat(allLabeled{j,1});
    frameName = cell2mat(allLabeled{j,2});
%     numOfLabels = allLabeled{j,3};
    labeledPositions = allLabeled{j,4};
    performanceRecord{j,5} = [];
    [modArea ,baselineArea,xmin,ymin,wid,len]= CompareAconBrgbSiftrgbModlab(panoName, frameName, ...
            11 , iter,boxRatio,ransacThre,labeledPositions,patch_w, win_size);
    close 11
    Area(1,j) = modArea;
    Area(2,j) = baselineArea;
end

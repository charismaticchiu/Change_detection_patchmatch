close all
clear all
j = 1;
iter = 4;
boxRatio = 6;
ransacThre = 200;
labeledPositions={[100,100,100,100],[140,340,100,60]};
numOfLabels = size(labeledPositions,2);
panoName = './video/YV3JZtNGd84/patchmatch_thres/pano_wT_wNy_-euFFFixtbUkAIA_0.jpg';
frameName = './video/YV3JZtNGd84/patchmatch_thres/image-00305.jpg';




[xmin,ymin,wid,len]= changeDetectAconBsiftModLAB(panoName, frameName, ...
        j * 11 , iter,boxRatio,ransacThre,labeledPositions,1,200);

overlapThre = 0.3;
ratio = ones(numOfLabels,6);

for i = 1:numOfLabels
    for k = 1:6
        overlapArea = rectint([xmin(k),ymin(k),wid(k),len(k)],labeledPositions{i});
        ratio(i,k) = overlapArea/(labeledPositions{i}(3) * labeledPositions{i}(4) + wid(k) * len(k) - overlapArea);            
    end
end

%%%%%%
for usedPatchNum = 1:6
    ratioCalc = ratio;
    %n = n + 1;
    hit = 0;
    disp(['The i-th',num2str(usedPatchNum)])
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

figure;
plot( recall, precision );
ylabel('Precision','FontSize',12);
xlabel('Recall','FontSize',12);
area = 0;
%%%%%%%
for i = 1:usedPatchNum-1
    area = area + (precision(i) + precision(i+1)) *  (recall(i+1) - recall(i) ) / 2;
end

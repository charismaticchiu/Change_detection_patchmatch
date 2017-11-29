%A: Pano/croped area; B:dash cam
%PAtch Match using A to reconstruct B
function  [area,xmin,ymin,wid,len] = fig6(pathA,pathB,figNum, iter, boxRatio, ransacThre,  labeledPositions, patch_w, win_size)
%     tic;
    %% patch match param initialization
%     clear all;
% close all;
    patchNum = 5;
    xmin(1:patchNum) = 1;
    ymin(1:patchNum) = 1;
    wid(1:patchNum) = 1;
    len(1:patchNum) = 1;
    score(1:patchNum) = 0;
    cores = 4;    % Use more cores for more speed
    rs_ratio = 0.5;
    rs_iters = 1;    
    rs_max = 1;     
    numOfLabels = size(labeledPositions,2);
%     coef.minPtNum = 3;
%     coef.iterNum = 30;
%     coef.thDist = win_size^2;
%     coef.thInlrRatio = .6;
    
    if cores==1
        algo = 'cpu';
    else
        algo = 'cputiled';
    end
    %% Read imagesc
%     B=imread('./video/3iJrqEtXhiY/patchmatch_thres/imagesc-00001.jpeg');
%     A=imread('./video/3iJrqEtXhiY/patchmatch_thres/pano_vsQg4i6BHJtL7cR5DO9fNw_180.jpeg');
        
    B = imread(pathB);
    A = imread(pathA);
    
        %% Resize
%     r1 = (size(B,1)/size(A,1));   
    r2 = (size(B,2)/size(A,2));
%     initSize =  double(max (r1,r2))  ; 
    A = imresize(A, r2);  
%     B=B(1:end-1,1:end-1,:);%what is the purpose?    

%% SIFT & RANSAC
    
    A = im2single(A);
    B = im2single(B);
    siftInfoPath = strcat('./video/Label/sift_',pathB(strfind(pathB,'image'):end-4),'_',pathA(strfind(pathA,'pano'):end-4),'.mat');
    if exist(siftInfoPath,'file') == 2
    
        load(siftInfoPath);
    else
        [f1,d1] = vl_sift(rgb2gray(A)) ;
        [f2,d2] = vl_sift(rgb2gray(B)) ; 
        
    
        [matches, scores] = vl_ubcmatch(d1,d2) ;

        numMatches = size(matches,2) ;

        X1 = f1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
        X2 = f2(1:2,matches(2,:)) ; X2(3,:) = 1 ;

        s1 = size(X1,2);
        s2 = size(X2,2);

        for t = 1:100
            % estimate affine
            subset = vl_colsubset(1:numMatches, 3) ;
            [T{t}] = estimateRigidTransform(X1(:,subset),X2(:,subset));

            % score
            errs{t} = abs([X1;ones(1,s1)] - T{t}*[X2;ones(1,s2)]);
            errs{t} = sum(errs{t}(1:2,:),1);
            score(t) = sum(errs{t}<ransacThre);        
        end

        [~,ind] = max(score);
        Test = T{ind};
        save(siftInfoPath,'f1','f2','d1','d2','Test');
    end
    %% Create mask
    dir = strcat('./paperFigures');
    frameNum = str2double(pathB(end-8:end-4));
%     anotherFrameNum = mod((frameNum + 30), 100);
    anotherFrameNum = frameNum + 30;
    if(anotherFrameNum <= 99 )
        C = strcat(pathB(1:end-6), num2str(anotherFrameNum),'.jpg') ;  
    elseif(anotherFrameNum > 99)
        C = strcat(pathB(1:end-7), num2str(anotherFrameNum),'.jpg') ;  
    end
    
    if exist(C,'file') ~= 2
        anotherFrameNum = frameNum - 30;
        if(anotherFrameNum <= 9 )
            C = strcat(pathB(1:end-6),'0',num2str(anotherFrameNum),'.jpg');
        elseif(anotherFrameNum <= 99)
            C = strcat(pathB(1:end-7),'0', num2str(anotherFrameNum),'.jpg') ;  
        elseif(anotherFrameNum <= 999)
            C = strcat(pathB(1:end-8),'0',num2str(anotherFrameNum),'.jpg') ;  
        elseif(anotherFrameNum <= 9999)
            C = strcat(pathB(1:end-9),'0',num2str(anotherFrameNum),'.jpg') ;  
        end    
    end
%     C = im2double(imread(C));
    C = imread(C);
    colorTransform = makecform('srgb2lab');
    
    labC = applycform(C, colorTransform);
%     labB = applycform(im2double(imread(pathB)), colorTransform);
    labB = applycform(imread(pathB), colorTransform);
    figure(1)
    image(labC);
    colormap(bone)
    axis off
    print(strcat(dir,'/6f'),'-djpeg','-r500')
    close 1;
    
    figure(1)
    image(labB);
    colormap(bone)
    axis off
    print(strcat(dir,'/6g'),'-djpeg','-r500')
    close 1;
    
    
    mask = abs(labB - labC);
    mask = sum(mask,3);
%     mask = mask(1:end-patch_w+1,1:end-patch_w+1);
    mask = mask./max(mask(:));
    figure(1)
    imagesc(mask);
    colormap(bone)
    axis off
    print(strcat(dir,'/6b'),'-djpeg','-r500')
    close 1;
    
    
    %% Initialize bnn0
    bnn0(size(B,1),size(B,2),3) = 0;
    [X,Y] = meshgrid(1:size(B,1),1:size(B,2));
    coord = [X(:)';Y(:)'];
    coord = [coord;ones(2,size(coord,2))];
    temp = Test * coord;
%     rrr = reshape(temp(1,:),[size(B,2),size(B,1)])';
    bnn0(:,:,1) = reshape(temp(1,:),[size(B,2),size(B,1)])';
    bnn0(:,:,2) = reshape(temp(2,:),[size(B,2),size(B,1)])';
   
    bnn0 = int32(bnn0);
    
    %% Display reconstruction with Patch Match
    
    %Initial guess mode run for "iter" iterations
    bnnp = nnmex(B, A, algo, patch_w, iter, rs_max, [], rs_ratio, rs_iters, cores, [], [win_size, win_size], bnn0, [], [], []);
    
%     disp(['Time for pricessing a sigle pair of imagescs: ', num2str(toc), ' sec']);
    
    error = bnnp(:,:,3);
    error = error(1:end-patch_w+1,1:end-patch_w+1);
    figure(1);
    imagesc(error)
    colormap(bone)
    axis off
    print(strcat(dir,'/6a'),'-djpeg','-r500')
    close 1;
    
    
    error = error./(patch_w^2.5);
    figure(1);
    imagesc(A)
    colormap(bone)
    axis off
    print(strcat(dir,'/6e'),'-djpeg','-r500')
    close 1;
%     sum(sum(error))
    
%     mean_bnnp3 = mean(mean(error))
%     [~, bnnp3x_max]=max(max(bnnp(:,:,3),[],1));
%     [~, bnnp3y_max]=max(max(bnnp(:,:,3),[],2));
%     disp(['Max distance of annp channel-3: ',num2str(bnnp(bnnp3y_max,bnnp3x_max,3)) ]);
    disp(['labMod rgbPM Prc PANO: ',pathA(strfind(pathA,'pano')+4:end-4),' FRAME: ',pathB(strfind(pathB,'imagesc'):end-4), ...
        ' WIN_S: ',num2str(win_size),' BOXR: ',num2str(boxRatio),' PATCH_S: ',num2str(patch_w)]);
    
    
    sfigure(figNum) ;% L2-Distance with 2st patchMatch and Initial guess
%     imagesc(annp(:,:,3),[]);
    
    doubleBnnpCh3 = double(error);
    
%     tThre = boxRatio * mean_bnnp3;
    maskDoubleBnnpCh3 =  doubleBnnpCh3 .* mask;
    figure(1)
    imagesc(maskDoubleBnnpCh3);
    colormap(bone)
    axis off
    print(strcat(dir,'/6c'),'-djpeg','-r500')
    close 1;
    
    
%     std(doubleBnnpCh3(:))
%     std(maskDoubleBnnpCh3(:))

%     median_bnnp3 = double(median(maskDoubleBnnpCh3(:)));
%     median_bnnp3 = double(median(doubleBnnpCh3(:)))

%     tThre = boxRatio * median_bnnp3;
    pTile = boxRatio * 3 + 50;
    tThre = prctile(maskDoubleBnnpCh3(:),pTile);
    unmatched = maskDoubleBnnpCh3 -  tThre;% could set as a variable
%     std(unmatched(:))
    
%     subplot(221) ,imagesc(maskDoubleBnnpCh3);
    figure(1)
    imagesc(B)
    for i = 1: size(labeledPositions,2)
        rectangle('position',[labeledPositions{i}(1), labeledPositions{i}(2), ...
                labeledPositions{i}(3), labeledPositions{i}(4)],'edgecolor','b','LineWidth',2)
    end
    axis off
    print(strcat(dir,'/6d'),'-djpeg','-r500')
    close 1;
    
    
    figure(1)
    imagesc(B)
    axis off
    print(strcat(dir,'/6h'),'-djpeg','-r500')
    close 1;
    
    
    unmatched = double(unmatched);

    hold on;
    color = ['r';'g';'w';'m';'c';'y'];

    for i=1:patchNum       
        [ymin1, ymax1, xmin1, xmax1, val1] = maxsubarray2D(unmatched);
        unmatched(ymin1:ymax1,xmin1:xmax1) = 0;
       
        if (ymax1 - ymin1 > 0 ) && (xmax1 - xmin1 > 0 )% && ymax1 <= size(unmatched,1) * 0.7 && ymax1 >= size(unmatched,1) * 0.1 
            rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor',color(i),'LineWidth',2)
            xmin(i) = xmin1;
            ymin(i) = ymin1;
            wid(i) = xmax1-xmin1;
            len(i) = ymax1 - ymin1;
            score(i) = val1 + wid(i) * len(i) * tThre;      
        end

    end
    hold off;

    subplot(223) ,imagesc(B);
    
    hold on;
    for i=1:patchNum                  
        rectangle('position',[xmin(i), ymin(i), wid(i), len(i)],'edgecolor',color(i),'LineWidth',2)
    end
    for i = 1: size(labeledPositions,2)
        rectangle('position',[labeledPositions{i}(1), labeledPositions{i}(2), ...
                labeledPositions{i}(3), labeledPositions{i}(4)],'edgecolor','b','LineWidth',2)
    end
    hold off

    subplot(224) ,imagesc(A);
    


    overlapThre = 0.3;
    ratio = ones(numOfLabels,patchNum);

    for i = 1:numOfLabels
        for k = 1:patchNum
            overlapArea = rectint([xmin(k),ymin(k),wid(k),len(k)],labeledPositions{i});
            ratio(i,k) = overlapArea/(labeledPositions{i}(3) * labeledPositions{i}(4) + wid(k) * len(k) - overlapArea);            
        end
    end

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
    
    subplot(222);
    plot( recall, precision );
    title(['AP: ',num2str(area)]);                
    xlim([0 1.1])
    ylim([0 1.1])
    ylabel('Precision','FontSize',12);
    xlabel('Recall','FontSize',12);
    
end

function d = calcDist(H,pts1,pts2)

pts3 = H*[pts2;ones(1,size(pts2,2))];
pts3(4,:) = [];
d = sum((pts1-pts3).^2,1);

end
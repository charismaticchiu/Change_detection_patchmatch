%A: Pano/croped area; B:dash cam
%PAtch Match using A to reconstruct B
function  [xmin,ymin,wid,len] = changeDetectAconBrgbSiftrgbModlabPMCalc(pathA,pathB,figNum, iter, boxRatio, ransacThre,  labeledPositions, patch_w, win_size)
%     tic;
    %% patch match param initialization

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
    %% Read image
%     B=imread('./video/3iJrqEtXhiY/patchmatch_thres/image-00001.jpg');
%     A=imread('./video/3iJrqEtXhiY/patchmatch_thres/pano_vsQg4i6BHJtL7cR5DO9fNw_180.jpg');    
    
    B = imread(pathB);
    A = imread(pathA);
    
        %% Resize
%     r1 = (size(B,1)/size(A,1));   
    r2 = (size(B,2)/size(A,2));
%     initSize =  double(max (r1,r2))  ; 
    A = imresize(A, r2);  
%     B=B(1:end-1,1:end-1,:);%what is the purpose?    

%% SIFT & RANSAC
    colorTransform = makecform('srgb2lab');
    
    labA = applycform(A, colorTransform);
    labB = applycform(B, colorTransform);
    
    labA = im2double(labA);
    labB = im2double(labB);
        
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
    C = im2double(imread(C));
    
    
    mask = abs(im2double(imread(pathB)) - C);
    mask = sum(mask,3);
    mask = mask(1:end-patch_w+1,1:end-patch_w+1);
    mask = mask./max(mask(:));
    %% visualize
%     im1 = labA;
%     im2 = labB;
%     dh1 = max(size(im2,1)-size(im1,1),0) ;
%     dh2 = max(size(im1,1)-size(im2,1),0) ;
%     
%     figure(1) ; clf ;
%     subplot(2,1,1) ;
%     imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
%     o = size(im1,2) ;
%     line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
%         [f1(2,matches(1,:));f2(2,matches(2,:))]) ;
%     title(sprintf('%d tentative matches', numMatches)) ;
%     axis image off ;
%     
%     subplot(2,1,2) ;
%     imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
%     o = size(im1,2) ;
%     ok = errs{ind}<thre;
%     line([f1(1,matches(1,ok));f2(1,matches(2,ok))+o], ...
%         [f1(2,matches(1,ok));f2(2,matches(2,ok))]) ;
%     title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
%         sum(ok), ...
%         100*sum(ok)/numMatches, ...
%         numMatches)) ;
%     axis image off ;
%     
%     drawnow ;
    
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
    bnnp = nnmex(labB, labA, algo, patch_w, iter, rs_max, [], rs_ratio, rs_iters, cores, [], [win_size, win_size], bnn0, [], [], []);
    
%     disp(['Time for pricessing a sigle pair of images: ', num2str(toc), ' sec']);
    
    error = bnnp(:,:,3);
    error = error(1:end-patch_w+1,1:end-patch_w+1);
    error = error./(patch_w^2.5);
%     sum(sum(error))
%     median_bnnp3 = double(median(error(:)));
%     mean_bnnp3 = mean(mean(error))
%     [~, bnnp3x_max]=max(max(bnnp(:,:,3),[],1));
%     [~, bnnp3y_max]=max(max(bnnp(:,:,3),[],2));
%     disp(['Max distance of annp channel-3: ',num2str(bnnp(bnnp3y_max,bnnp3x_max,3)) ]);
    
    disp(['rgbMod labPM PANO: ',pathA(strfind(pathA,'pano'):end),' FRAME: ',pathB(strfind(pathB,'image'):end), ...
        ' WIN_S: ',num2str(win_size),' BOXR: ',num2str(boxRatio),' PATCH_S: ',num2str(patch_w)]);
    sfigure(figNum) ;% L2-Distance with 2st patchMatch and Initial guess
%     imshow(annp(:,:,3),[]);
    
    doubleBnnpCh3 = double(error);
    
%     tThre = boxRatio * mean_bnnp3;
    maskDoubleBnnpCh3 =  doubleBnnpCh3 .* mask;
%     median_bnnp3 = double(median(maskDoubleBnnpCh3(:)));
    median_bnnp3 = double(median(doubleBnnpCh3(:)));
    tThre = boxRatio * median_bnnp3;
    unmatched = maskDoubleBnnpCh3 -  tThre;% could set as a variable
    subplot(221) ,imagesc(maskDoubleBnnpCh3);
    for i = 1: size(labeledPositions,2)
        rectangle('position',[labeledPositions{i}(1), labeledPositions{i}(2), ...
                labeledPositions{i}(3), labeledPositions{i}(4)],'edgecolor','b','LineWidth',2)
    end
    unmatched = double(unmatched);
%     min(min(unmatched))
    hold on;
    color = ['r';'g';'w';'m';'c';'y'];
%     l = size(unmatched,1);
%     unmatched( round(l*0.7) :end, 1:end) = 0;    
%     unmatched(1: round(l*0.05) , 1:end) = 0;
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
%         else
%             [ymin1, ymax1, xmin1, xmax1, val1] = maxsubarray2D(unmatched);
%             unmatched(ymin1:ymax1,xmin1:xmax1) = 0;
%             if (ymax1 - ymin1 > 0 ) && (xmax1 - xmin1 > 0 ) && ymax1 <= size(unmatched,1) * 0.7 && ymax1 >= size(unmatched,1) * 0.1                  
%                 rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor',color(i),'LineWidth',2)
%                 xmin(i) = xmin1;
%                 ymin(i) = ymin1;
%                 wid(i) = xmax1-xmin1;
%                 len(i) = ymax1 - ymin1;
%                 score(i) = val1 + wid(i) * len(i) * tThre;
%             end
        end
    end
    hold off;
%     subplot(222) ,imagesc(A);
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
%     subplot(224) ,imagesc(unmatched);
    subplot(224) ,imagesc(A);
    
%     extWid = size(B,2)*0.05;
%     extWid = 50;
%     extHit = 50;
%     
%     for i=1:patchNum        
%         range= [max(xmin(i)- extWid,1), min(xmin(i) + wid(i) + extWid,size(B,2)),...
%             max(1,ymin(i) - extHit), min(ymin(i) + len(i) + extHit, size(B,1))];%l,r,u,d
%         [cor1,cor2] = meshgrid( range(1): range(2), range(3): range(4) ); 
%         cor1(ymin(i): ymin(i) + len(i), xmin(i):xmin(i)+wid(i)) = 0;
%         cor2(ymin(i): ymin(i) + len(i), xmin(i):xmin(i)+wid(i)) = 0;
%         pts2 = [cor1(:)';cor2(:)'];       
%         chX = bnnp( range(3): range(4), range(1): range(2), 1);
%         chY = bnnp( range(3): range(4), range(1): range(2), 2);
%         chX(ymin(i): ymin(i) + len(i), xmin(i):xmin(i)+wid(i)) = 0;
%         chY(ymin(i): ymin(i) + len(i), xmin(i):xmin(i)+wid(i)) = 0;
%         pts1 = reshape(chX,1,[]);%X-channel
%         pts1(2,:) = reshape(chY,1,[]);%Y-channel
% %         whos('pts1')
% %         whos('pts2')
%         displacement = pts2 - double(pts1) ;
%         disX = sum(displacement(1,:))/(size(displacement,2) - len(i) * wid(i));
%         disY = sum(displacement(2,:))/(size(displacement,2) - len(i) * wid(i));
%         rectangle('position',[xmin(i)+disX, ymin(i)+disY, wid(i), len(i)],'edgecolor',color(i),'LineWidth',2)        
%         
%     end

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
    dir = strcat('./video/Label/rgbSiftrgbModlabPM/ransacThre',...
        num2str(ransacThre),'AconsBiter',num2str(iter),'/boxR',num2str(boxRatio),'winSize',num2str(win_size),'patchW',num2str(patch_w));
    if(isequal(exist(dir, 'dir'),7))  
        print(strcat(dir,'/',pathB(strfind(pathB,'image'):end-4),'__',pathA(strfind(pathA,'pano'):end-4)),'-dpng','-r250')
    else 
        mkdir(dir);
        print(strcat(dir,'/',pathB(strfind(pathB,'image'):end-4),'__',pathA(strfind(pathA,'pano'):end-4)),'-dpng','-r250')
    end
end

function d = calcDist(H,pts1,pts2)

pts3 = H*[pts2;ones(1,size(pts2,2))];
pts3(4,:) = [];
d = sum((pts1-pts3).^2,1);

end
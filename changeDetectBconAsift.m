%A: Pano/croped area; B:dash cam
%PAtch Match using A to reconstruct B
function  [score1,score2,score3] = changeDetectBconAsift(pathA,pathB,videoName, figNum, iter, boxRatio, thre)
%     tic;
    %% patch match param initialization
%     clear all;
% close all;
     xmin(3) = 0;
    ymin(3) = 0;
    wid(1:3) = 1;
    len(1:3) = 1;
    cores = 4;    % Use more cores for more speed
    rs_ratio = 0.5;
    rs_iters = 1;
    patch_w = 1;
    rs_max = 1; 
    score1 = 0;
    score2 = 0;
    score3 = 0;
    coef.minPtNum = 3;
    coef.iterNum = 30;
    coef.thDist = 500;
    coef.thInlrRatio = .01;
    
    if cores==1
        algo = 'cpu';
    else
        algo = 'cputiled';
    end
    %% Read image
%     B=imread('./data/1/image-024.jpg');
%     A=imread('./data/1/pano_crop.jpg');
    B = imread(pathB);
    A = imread(pathA);
    A = im2single(A);
    B = im2single(B);

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
        [T{t}] = estimateRigidTransform(X2(:,subset),X1(:,subset));
        
        % score
        errs{t} = abs([X2;ones(1,s2)] - T{t}*[X1;ones(1,s1)]);
        errs{t} = sum(errs{t}(1:2,:),1);
        score(t) = sum(errs{t}<thre);        
    end
    [~,ind] = max(score);
    Test = T{ind};
    
%     % visualize
%     im1 = A;
%     im2 = B;
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
    
    %% Resize
%     r1 = (size(B,1)/size(A,1));   
%     r2 = (size(B,2)/size(A,2));
%     initSize =  double(max (r1,r2))  ; 
%     A = imresize(A, initSize);  
%     B=B(1:end-1,1:end-1,:);%what is the purpose?
    bnn0(size(B,1),size(B,2),3) = 0;
    %% Initialize bnn0
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
    bnnp = nnmex(B, A, algo, patch_w, iter, rs_max, [], rs_ratio, rs_iters, cores, [], [], bnn0, [], [], []);
    
    %  hold on
    
%     disp(['Time for pricessing a sigle pair of images: ', num2str(toc), ' sec']);
    max_bnnp3 = max(max(bnnp(:,:,3)));
    median_bnnp3 = median(median(bnnp(:,:,3)));
    mean_bnnp3 = mean(mean(bnnp(:,:,3)));
    [~, bnnp3x_max]=max(max(bnnp(:,:,3),[],1));
    [~, bnnp3y_max]=max(max(bnnp(:,:,3),[],2));
    disp(['Max distance of annp channel-3: ',num2str(bnnp(bnnp3y_max,bnnp3x_max,3)) ]);
    h(figNum) = sfigure(figNum) ;% L2-Distance with 2st patchMatch and Initial guess
%     imshow(annp(:,:,3),[]);
    
    doubleBnnp = double(bnnp(:,:,3));
    
    subplot(221) ,imagesc(doubleBnnp);
    unmatched = doubleBnnp- boxRatio * mean_bnnp3 ;% could set as a variable
    for i=1:3        
        [ymin1, ymax1, xmin1, xmax1, val1] = maxsubarray2D(double(unmatched));
        unmatched(ymin1:ymax1,xmin1:xmax1) = 0;
%         disp(['Val of Maxsubarray2D: ',num2str(val1) ]);
        if (ymax1 - ymin1 > 0 ) && (xmax1 - xmin1 > 0 )
            if i ==1
                score1 = val1;
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','r','LineWidth',2)
                xmin(1) = xmin1;
                ymin(1) = ymin1;
                wid(1) = xmax1-xmin1;
                len(1) = ymax1 - ymin1;
            elseif i ==2
                score2 = val1;
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','g','LineWidth',2)
                xmin(2) = xmin1;
                ymin(2) = ymin1;
                wid(2) = xmax1-xmin1;
                len(2) = ymax1 - ymin1;
            else
                score3 = val1;
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','w','LineWidth',2)
                xmin(3) = xmin1;
                ymin(3) = ymin1;
                wid(3) = xmax1-xmin1;
                len(3) = ymax1 - ymin1;
            end
        end
    end
    subplot(222) ,imagesc(A);
    subplot(223) ,imagesc(B);
    color = ['r','g','w'];
    for i=1:3                  
        rectangle('position',[xmin(i), ymin(i), wid(i), len(i)],'edgecolor',color(i),'LineWidth',2)
    end
    subplot(224) ,imagesc(A);hold on; 
    for i=1:3      
        X = reshape(bnnp(ymin(i): ymin(i) + len(i), xmin(i): xmin(i) + wid(i), 1),1,[]);
        Y = reshape(bnnp(ymin(i): ymin(i) + len(i), xmin(i): xmin(i) + wid(i), 2),1,[]);
        [cor1,cor2] = meshgrid(xmin(i):xmin(i)+wid(i),ymin(i) : ymin(i)+ len(i));
        
        pts2 = [cor1(:)';cor2(:)']; pts2(3,:) = 1;               
        pts1 = double([X;Y;ones(1,size(X,2))]);        
        [~,inlierIdx]=ransac1(pts1,pts2,coef,@estimateRigidTransform,@calcDist);
        pts1(3,:) = [];
        if i==1
            plot(pts1(inlierIdx),'r.');
        elseif i==2
            plot(pts1(inlierIdx),'g.');
        else
            plot(pts1(inlierIdx),'w.');
        end
        
    end

    dir = strcat('./video/',videoName,'/Modulated/sift/withResizePatchMatch/Thre',num2str(thre),'/AconsBiter',num2str(iter),'boxR',num2str(boxRatio));
    if(isequal(exist(dir, 'dir'),7))    
%         saveas(h(figNum) ,[dir,'/',pathB(strfind(pathB,'image'):end-4),'__',pathA(strfind(pathA,'pano'):end)]);
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
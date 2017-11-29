%A: Pano/croped area; B:dash cam
%PAtch Match using A to reconstruct B
function  [score1,score2,score3,tform] = changeDetectAconBwithMod(pathA,pathB,videoNum, figNum, iter, boxRatio)
%     tic;
    %% patch match param initialization
    %clear all;
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
    %% Create mask
    frameNum = str2num(pathB(end-8:end-4));
    anotherFrameNum = mod((frameNum + 30), 100);
    if(anotherFrameNum > 9 )
        C = [pathB(1:end-7),'0' ,num2str(anotherFrameNum),'.jpg'];
    else 
        C = [pathB(1:end-5), num2str(anotherFrameNum),'.jpg'] ;  
    end
    C = double(imread(C));
    mask = abs(double(B) - double(C));
    mask = sum(mask,3);
    
    mask = mask./max(mask(:));
    %% Resize
    r1 = (size(B,1)/size(A,1));   
    r2 = (size(B,2)/size(A,2));
    initSize =  double(max (r1,r2))  ; 
    A = imresize(A, initSize);  
%     B=B(1:end-1,1:end-1,:);%what is the purpose?
    bnn0(size(B,1),size(B,2),3) = 0;
    %% Initialize bnn0
    for j=1:size(B,2)
        for i=1:size(B,1)
            bnn0(i,j,1)=j; % x-channel
            bnn0(i,j,2)=i; % y-channel
            bnn0(i,j,3)=0; % L2-norm
        end
    end
    bnn0 = int32(bnn0);
    %bnn = nnmex(B, A, algo, patch_w, [], rs_max, [], rs_ratio, rs_iters, cores, [], [], [], [], [], []);
    %% Display L2-Distance and reconstruction w/ ann0
%      figure % 
%      imshow(ann0(:,:,3), []); % fig.3
%     figure
%      imshow(votemex(B, ann0, [],algo,patch_w));

    %% Display reconstruction with Patch Match

    %Initial guess mode run for "iter" iterations
    bnnp = nnmex(B, A, algo, patch_w, iter, rs_max, [], rs_ratio, rs_iters, cores, [], [], bnn0, [], [], []);
    
    %  hold on
%     disp(['Time for pricessing a sigle pair of images: ', num2str(toc), ' sec']);
    max_bnnp3 = max(max(bnnp(:,:,3)));
%     median_bnnp3 = median(median(bnnp(:,:,3)));
    mean_bnnp3 = mean(mean(bnnp(:,:,3)));
    [M, bnnp3x_max]=max(max(bnnp(:,:,3),[],1));
    [M, bnnp3y_max]=max(max(bnnp(:,:,3),[],2));
    disp(['Max distance of annp channel-3: ',num2str(bnnp(bnnp3y_max,bnnp3x_max,3)) ]);
    h(figNum) = sfigure(figNum) ;% L2-Distance with 2st patchMatch and Initial guess
%     imshow(annp(:,:,3),[]);
    
    doubleBnnp = double(bnnp(:,:,3));
    
    modBnnp = doubleBnnp.* mask;
    subplot(221) ,imagesc(modBnnp);
    unmatched = modBnnp- boxRatio * mean_bnnp3 ;% could set as a variable
    for i=1:3        
        [ymin1, ymax1, xmin1, xmax1, val1] = maxsubarray2D(double(unmatched));
        unmatched(ymin1:ymax1,xmin1:xmax1) = 0;
        disp(['Val of Maxsubarray2D: ',num2str(val1) ]);
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


    dir = ['./video/',num2str(videoNum),'/Modulated/withResizePatchMatch/AconsBiter',num2str(iter),'boxR',num2str(boxRatio)];
    if(isequal(exist(dir, 'dir'),7))    
        saveas(h(figNum) ,[dir,'/',pathB(11:end-4),'__',pathA(11:end)]);
    else 
       mkdir(dir);
        saveas(h(figNum) ,[dir,'/',pathB(11:end-4),'__',pathA(11:end)]); 
    end
end
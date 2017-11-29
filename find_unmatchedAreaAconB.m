%A: cropped area; B:dash cam
%PAtch Match using A to reconstruct B
function  find_unmatchedAreaAconB(pathA,pathB,videoNum, figNum, iter, boxRatio)
%     tic;
    %% patch match param initialization
    %clear all;
    cores = 4;    % Use more cores for more speed
    rs_ratio = 0.5;
    rs_iters = 1;
    patch_w = 1;
    rs_max = 1; 
    if cores==1
      algo = 'cpu';
    else
      algo = 'cputiled';
    end
    %% Read image
%     B=imread('./data/1/image-024.jpg');
%     A=imread('./data/1/pano_crop.jpg');
    B=imread(pathB);
    A=imread(pathA);
    %% Resize
%     r1 = (size(B,1)/size(A,1));   
%     r2 = (size(B,2)/size(A,2));
%     initSize =  double(max (r1,r2))  ; 
%     A = imresize(A, initSize);  
    B=B(1:end-1,1:end-1,:);%what is the purpose?
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
    median_bnnp3 = median(median(bnnp(:,:,3)));
    mean_bnnp3 = mean(mean(bnnp(:,:,3)));
    [M, bnnp3x_max]=max(max(bnnp(:,:,3),[],1));
    [M, bnnp3y_max]=max(max(bnnp(:,:,3),[],2));
    disp(['Max distance of annp channel-3: ',num2str(bnnp(bnnp3y_max,bnnp3x_max,3)) ]);
    h(figNum) = sfigure(figNum) ;% L2-Distance with 2st patchMatch and Initial guess
%     imshow(annp(:,:,3),[]);
    subplot(221) ,imagesc(bnnp(:,:,3));
    unmatched = bnnp(:,:,3)- boxRatio * mean_bnnp3 ;% could set as a variable
    for i=1:3        
        [ymin1, ymax1, xmin1, xmax1, val1] = maxsubarray2D(double(unmatched))
        unmatched(ymin1:ymax1,xmin1:xmax1) = 0;
        disp(['Val of Maxsubarray2D: ',num2str(val1) ]);
        if (ymax1 - ymin1 > 0 ) && (xmax1 - xmin1 > 0 )
            if i ==1
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','r','LineWidth',2)
            elseif i ==2
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','g','LineWidth',2)
            else
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','w','LineWidth',2)
            end
        end
    end
    subplot(222) ,imagesc(A);
    subplot(223) ,imagesc(B);
    unmatched = bnnp(:,:,3)- boxRatio * mean_bnnp3 ;% could set as a variable
    for i=1:3        
        [ymin1, ymax1, xmin1, xmax1, val1] = maxsubarray2D(double(unmatched));
        unmatched(ymin1:ymax1,xmin1:xmax1) = 0;
%         disp(['Val of Maxsubarray2D: ',num2str(val1) ]);
        if (ymax1 - ymin1 > 0 ) && (xmax1 - xmin1 > 0 )
            if i ==1
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','r','LineWidth',2)
            elseif i ==2
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','g','LineWidth',2)
            else
                rectangle('position',[xmin1, ymin1, xmax1-xmin1, ymax1 - ymin1],'edgecolor','w','LineWidth',2)
            end
        end
    end

%     imagesc(annp(:,:,3)),axis image off;

%     dir = ['./video/',num2str(videoNum),'/withResizePatchMatch/AconsBiter',num2str(iter),'boxR',num2str(boxRatio)];
%     if(isequal(exist(dir, 'dir'),7))    
%         saveas(h(figNum) ,[dir,'/',pathB(11:end-4),'__',pathA(11:end)]);
%     else 
%        mkdir(dir);
%         saveas(h(figNum) ,[dir,'/',pathB(11:end-4),'__',pathA(11:end)]); 
%     end
end
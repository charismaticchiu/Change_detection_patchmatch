%A: cropped area; B:dash cam
%%PAtch Match using B to reconstruct A
function  find_unmatchedAreaBconA(pathA,pathB,videoNum, figNum, iter, boxRatio)
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
    % Read image
%     B=imread('./data/1/image-024.jpg');
%     A=imread('./data/1/pano_crop.jpg');
    B=imread(pathB);
    A=imread(pathA);
    %% Resize
    r1 = (size(B,1)/size(A,1));   
    r2 = (size(B,2)/size(A,2));
    initSize =  double(max (r1,r2))  ; 
    A = imresize(A, initSize);  
    B=B(1:end-1,1:end-1,:);%what is the purpose?
    ann0(size(A,1),size(A,2),3) = 0;
    %% Initialize ann0
    for j=1:size(A,2)
        for i=1:size(A,1)
            ann0(i,j,1)=j; % x-channel
            ann0(i,j,2)=i; % y-channel
            ann0(i,j,3)=0; % L2-norm
        end
    end
    ann0 = int32(ann0);
    %bnn = nnmex(B, A, algo, patch_w, [], rs_max, [], rs_ratio, rs_iters, cores, [], [], [], [], [], []);
    %% Display L2-Distance and reconstruction w/ ann0
%      figure % 
%      imshow(ann0(:,:,3), []); % fig.3
%     figure
%      imshow(votemex(B, ann0, [],algo,patch_w));

    %% Display reconstruction with Patch Match

    %Initial guess mode run for "iter" iterations
    annp = nnmex(A, B, algo, patch_w, iter, rs_max, [], rs_ratio, rs_iters, cores, [], [], ann0, [], [], []);
    
    %  hold on
%     disp(['Time for pricessing a sigle pair of images: ', num2str(toc), ' sec']);
    max_annp3 = max(max(annp(:,:,3)));
    median_annp3 = median(median(annp(:,:,3)));
    mean_annp3 = mean(mean(annp(:,:,3)));
    [M, annp3x_max]=max(max(annp(:,:,3),[],1));
    [M, annp3y_max]=max(max(annp(:,:,3),[],2));
    disp(['Max distance of annp channel-3: ',num2str(annp(annp3y_max,annp3x_max,3)) ]);
    h(figNum) = sfigure(figNum) ;% L2-Distance with 2st patchMatch and Initial guess
     %     imshow(annp(:,:,3),[]);
    subplot(221) ,imagesc(annp(:,:,3));    
    unmatched = annp(:,:,3)- boxRatio* mean_annp3 ;% could set as a variable
    for i = 1:3
        [ymin1, ymax1, xmin1, xmax1, val1] = maxsubarray2D(double(unmatched));
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
    subplot(222) ,imagesc(B);
    
    
    subplot(223) ,imagesc(A);
    unmatched = annp(:,:,3)- boxRatio * mean_annp3 ;% could set as a variable
    for i = 1:3
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
    dir = ['./video/',num2str(videoNum),'/withResizePatchMatch/BconAiter',num2str(iter),'boxR',num2str(boxRatio)];
%     imagesc(annp(:,:,3)),axis image off;
    if(isequal(exist(dir, 'dir'),7))    
        saveas(h(figNum) ,[dir,'/',pathB(11:end-4),'__',pathA(11:end)]);
    else 
       mkdir(dir);
        saveas(h(figNum) ,[dir,'/',pathB(11:end-4),'__',pathA(11:end)]); 
    end

end
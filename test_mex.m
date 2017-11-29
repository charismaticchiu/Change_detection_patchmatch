%------------------------------------------------------------------------%
% Copyright 2008-2009 Adobe Systems Inc., for noncommercial use only.
% Citation:
%   Connelly Barnes, Eli Shechtman, Adam Finkelstein, and Dan B Goldman.
%   PatchMatch: A Randomized Correspondence Algorithm for Structural Image
%   Editing. ACM Transactions on Graphics (Proc. SIGGRAPH), 28(3), 2009
%   http://www.cs.princeton.edu/gfx/pubs/Barnes_2009_PAR/
% Main contact: csbarnes@cs.princeton.edu  (Connelly)
% Version: 1.0, 21-June-2008
%------------------------------------------------------------------------%

% Test 'image mode' nnmex, and votemex (see test_square.m and test_daisy.m for tests of 'descriptor mode' nnmex).
%keyboard
%close all;

close all;
clear all;
cores = 4;    % Use more cores for more speed
rs_ratio = 0.5;
rs_iters = 1;
patch_w = 1;
rs_max = 1; % 0.5*xb*sqrt((xa*ya)/(xb*yb));

if cores==1
  algo = 'cpu';
else
  algo = 'cputiled';
end

B=imread('./data/1/image-024.jpg');
A=imread('./data/1/pano_crop.jpg');

B=B(1:end-1,1:end-1,:);%what is the purpose?

for j=1:1280
    for i=1:625
        ann0(i,j,1)=j;%x-channel
        ann0(i,j,2)=i*(625/719);%y-channel
        ann0(i,j,3)=0;%L2-norm
    end
end
ann0 = int32(ann0);
% Benchmark
tic;
nnmex(A, B, algo, patch_w, [], rs_max, [], rs_ratio, rs_iters, cores, [], [], [], [], [], []);
nnmex(B, A, algo, patch_w, [], rs_max, [], rs_ratio, rs_iters, cores, [], [], [], [], [], []);
disp(['NN A <-> B time: ', num2str(toc), ' sec']);

% Display field
ann = nnmex(A, B, algo, patch_w, [], rs_max, [], rs_ratio, rs_iters, cores, [], [], [], [], [], []);
bnn = nnmex(B, A, algo, patch_w, [], rs_max, [], rs_ratio, rs_iters, cores, [], [], [], [], [], []);
% figure
% imshow(ann0(:,:,1), []);%fig.1
% figure
% imshow(ann0(:,:,2), []);%fig.2
figure%1st patchMatch L2Distance at each pixel
imshow(ann0(:,:,3), []);%fig.3
figure%reconstruction with 1st patchMatch
imshow(votemex(B, ann0,bnn,algo,patch_w));

%% Display reconstruction
%imshow(votemex(B, ann))       % Coherence %fig.4
%figure
%imshow(votemex(B, ann, bnn))  % BDS %fig.5
%%

% Test initial guess
tic;
annp = nnmex(A, B, algo, patch_w, 0, rs_max, [], rs_ratio, rs_iters, cores, [], [], ann0, [], [], []);
disp(['Initial guess mode run for 0 iterations: ', num2str(toc), ' sec']);

figure %reconstruction with 2st patchMatch and Initial guess
coarseA = imshow(votemex(B, annp,bnn,algo,patch_w));
% imshow(coarseA)       % Coherence
% imwrite(coarseA,'coarseRescontruct.jpg');


figure%L2Distance with 2st patchMatch and Initial guess
H=imshow(annp(:,:,3), []);%fig.6
% imsave(H);
max_annp3 = max(max(annp(:,:,3)));
median_annp3 = median(median(annp(:,:,3)));
[M, annp3x_max]=max(max(annp(:,:,3),[],1));
[M, annp3y_max]=max(max(annp(:,:,3),[],2));
annp(annp3y_max,annp3x_max,3) %Very strange about the index



%imshow(B);
%hold on 
%imshow(A)
%[annp3ypeak, annp3xpeak] = find(annp==max(annp(:,:,3)));

% %ann0(1:200,1:200) = 0;% what is the purpose?
% tic;
% annp = nnmex(A, B, algo, patch_w, [], rs_max, [], rs_ratio, rs_iters, cores, [], [], ann0, [], [], []);
% disp(['Initial guess mode run for 5 iterations: ', num2str(toc), ' sec']);
% figure
% imshow(votemex(B, annp))       % Coherence
% mean(mean(annp(:,:,3)))

%close all;
%% Test for memory leaks
%A=imresize(A,0.25);
%B=imresize(B,0.25);
%B=B(1:end-1,1:end-1,:);
%ann = nnmex(A, B); bnn = nnmex(B, A);
%
%user = memory;
%disp(['before memory leak test: ', num2str(user.MemUsedMATLAB/1e6), ' MB']);
%for i=1:100
%  ann = nnmex(A, B); bnn = nnmex(B, A);
%end
%user = memory;
%disp(['after memory leak test: ', num2str(user.MemUsedMATLAB/1e6), ' MB']);

pathA = './video/1/pano_38pKC4ScHBmmlsiO0Qpq0g_0.jpg'; 
pathB ='./video/1/image-263.jpg';
B=imread(pathB);% B as dash image
A=imread(pathA);% A as pano
template = double(rgb2gray(B)); 
A = double(rgb2gray(A));
r1 = (size(template,1)/size(A,1));
r2 = (size(template,2)/size(A,2));
initSize =  double(max (r1,r2))  ; 
A = imresize(A, initSize); 

tic
c1 = normxcorr2(template,A); % MATLAB original API
disp(['Time needed for MATLAB API: ',num2str(toc)]);
%%
tic
temp = A;
C = zeros(size(temp,1)+2*size(template,1)-2 ,size(temp,2)+2*size(template,2)-2 );
C(size(template,1):size(template,1)+size(temp,1)-1 , size(template,2):size(template,2)+size(temp,2)-1) = temp;
%c2 = normxcorr2_mex(template ,C , 'same'); % Code from UBC
c2 = cv.matchTemplate(C ,template , 'Method', 'CCorrNormed'); % Code from UBC
disp(['Time needed for mex: ',num2str(toc)]);
figure, surf(c1),shading flat
figure, surf(double(c2)),shading flat
clear all
num = 4*1;
z = zeros(num,1) ;
A = imread('./video/1/image-263.jpg');
tic
parfor i = 1:num 
    z(i,1) = i;
    h(i) = figure(i)
    imagesc(A);
    axis image off
    saveas(h(i),[num2str(i),'test.jpg']);
end
toc
m = zeros(num,1) ;
tic
for i = 1:num 
    figure(i),  imagesc(A);
    axis image off
    m(i,1) = i;
end
toc

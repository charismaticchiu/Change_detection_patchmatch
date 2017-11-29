function findFrame(frameNum)
load('./video/allLabeled.mat');
for i=1:100
    
    str = cell2mat(allLabeled{i,1});
    if isempty(findstr(str,frameNum))==0
        disp(num2str(i));
    end
end

end
function [matched, maxCoef, maxCoef2] =find_ann0(pathA,pathB,iter,videoNum,figNum) %matched is a boolean number, which denotes whether the image is a qualified one.
%     close all;
     
    expandRatio = 1.02;%
    B=imread(pathB);% B as dash image
    A=imread(pathA);% A as pano

    maxCoef = 0.0;
    maxCoef2 = 0.0;
    supR = 50; %Suppression radius
    [ypeak, xpeak, numOfIter, maxCoef, ratio, normMatrix, distToTop, distToLeft] = cropStreetView(double(rgb2gray(B)), double(rgb2gray(A)), iter, expandRatio);
%      [ypeak, xpeak, numOfIter, maxCoef, ratio, normMatrix] = cropStreetView(double(edge(rgb2gray(B),'Canny')), double(edge(rgb2gray(A),'Canny')), iter, 1.01);
    
    if (maxCoef == 0)
        disp('UNMATCHED PANO');
        matched = false;
        return
    end
    %A has to be expanded by the ratio
    A=imresize(A,ratio);

    yoffSet = gather(ypeak-size(B,1));
    xoffSet = gather(xpeak-size(B,2));
    
    %Make sure the up-left corner is properly located on the up-left
    %quarter of the image 
    if (yoffSet < size(A,1)) && (xoffSet < size(A,2))
        matched = true;
%         outputFileInfo = ['./video/',num2str(videoNum),'/outputInfo',num2str(videoNum),'.txt'];
%         infoID = fopen(outputFileInfo,'a+');
%         outputFileName = ['./video/',num2str(videoNum),'/output',num2str(videoNum),'.txt'];
%         pathID = fopen(outputFileName,'a+');
%         fprintf(infoID, ['number of iter: ',num2str(numOfIter),'; coef of normxcorr: ',num2str(maxCoef),'; A"s expanding ratio: ',num2str(ratio),'\n' ]);
%         
%         fprintf(infoID, ['Croped pano: ' ,pathA, '; counterpart dash cam image: ',pathB,'\n' ]);
%         fprintf(infoID, ['croped image path: ','./video/',num2str(videoNum),'/cropped/cropped_',pathA(16:end-4),'__',pathB(11:end),'\n\n']);
%         fprintf(pathID, ['./video/',num2str(videoNum),'/cropped/cropped_',pathA(16:end-4),'__',pathB(11:end),' ',pathB,'\n']);
      
        h(figNum) = sfigure(figNum);
%         disp(['normxcorr coefficient: ', num2str( maxCoef )]);
        %syntax of subplot
        subplot(221), imagesc(A),axis image off;
        title(['Coef: ',num2str(maxCoef),' Iter:',num2str( numOfIter),' MagRatio:',num2str(ratio)]);
        %The following 4 cases are to Make rectangle to be cropped not exceeding the borders 
        if (xoffSet + size(B,2)) > size(A,2)
            xlength = size(A,2)-xoffSet;
        else
            xlength = size(B,2);
        end
        
        if (yoffSet + size(B,1)) > size(A,1)
            ylength = size(A,1)-yoffSet;
        else
            ylength = size(B,1);
        end
        
        if xoffSet <= 1
             xoffSet = 1;
        end
        if yoffSet <= 1
             yoffSet = 1;
        end
        rectangle('position',[xoffSet, yoffSet, xlength, ylength],'edgecolor','r','LineWidth',1)

        
        disp(['number of iter: ',num2str(numOfIter),'; coef of normxcorr: ',num2str(maxCoef),'; A"s expanding ratio: ',num2str(ratio) ]);
  
        subplot(222), imagesc(B),axis image off;
        %overlap
        overlapAreaA = A(yoffSet:yoffSet + ylength-1, xoffSet: xoffSet + xlength -1 );
        overlapAreaB = B( size(B,1)- ylength +1 : size(B,1), size(B,2)- xlength +1 : size(B,2));
%         size(overlapAreaA ,1)
%         size(overlapAreaA ,2)
%         size(overlapAreaB ,1)
%         size(overlapAreaB ,2)
%         keyboard
%         overlaped = (overlapAreaA + overlapAreaB) /2;
        subplot(224), imshowpair(overlapAreaA,overlapAreaB,'blend'),axis image off;
        
        
%         Acropped=A(yoffSet : (yoffSet + ylength) , xoffSet : (xoffSet + xlength),:);
% 
%         imwrite(Acropped,['./video/',num2str(videoNum),'/cropped/cropped_',pathA(16:end-4),'__',pathB(11:end)],'jpg','Comment','Cropped after NCC')
%         fclose(infoID);
    else
        %If the the best match is not qualified w.r.t. my restriction then
        %return unmatched
        matched = false;
    end   
    
    %% Perform maximal suppression
    
    %If there is a best score matching, the we do the maximal suppression
    if matched

        supUpBound = ypeak - distToTop - supR;
        if supUpBound < 1
            supUpBound = 1;
        end
        supLeftBound = xpeak - distToLeft- supR;
        if supLeftBound < 1
            supLeftBound = 1;
        end
        supBotBound = ypeak - distToTop + supR;
        if supBotBound > size(normMatrix,1)
            supBotBound = size(normMatrix,1);
        end
        supRightBound = xpeak - distToLeft + supR;
        if supRightBound > size(normMatrix,2)
            supRightBound = size(normMatrix,2);
        end
        %Suppression!!!
        normMatrix(supUpBound : supBotBound, supLeftBound : supRightBound) = 0.0;

        [t, mi] = max(normMatrix);
        [maxCoef2, mj] = max(t);
        mi = mi(mj);
        xpeak2 = mj + distToLeft;
        ypeak2 = mi + distToTop ;
        yoffSet2 = gather(ypeak2-size(B,1));
        xoffSet2 = gather(xpeak2-size(B,2));
        if (yoffSet2 < size(A,1)) && (xoffSet2 < size(A,2))
            
            %syntax of subplot
            subplot(223), imagesc(A),axis image off;
            title(['Coef: ',num2str(maxCoef2), ' ratioTest:',num2str(maxCoef2/maxCoef)]);
            %The following 4 cases are to Make rectangle to be cropped not exceeding the borders 
            if (xoffSet2 + size(B,2)) > size(A,2)
                xlength2 = size(A,2)-xoffSet2;
            else
                xlength2 = size(B,2);
            end

            if (yoffSet2 + size(B,1)) > size(A,1)
                ylength2 = size(A,1)-yoffSet2;
            else
                ylength2 = size(B,1);
            end

            if xoffSet2 <= 1
                 xoffSet2 = 1;
            end
            if yoffSet2 <= 1
                 yoffSet2 = 1;
            end
            %Cropped area of the 2nd best score
            rectangle('position',[xoffSet2, yoffSet2, xlength2, ylength2],'edgecolor','w','LineWidth',1);
            
            
            disp(['Second best score of normxcorr: ', num2str(maxCoef2) ] );
            mkdir(['./video/',num2str(videoNum),'/normxcorrIter',num2str(iter)]);
            saveas(h(figNum) ,['./video/',num2str(videoNum),'/normxcorrIter',num2str(iter),'/',pathB(11:end-4),'__',pathA(11:end)]);
        
        else% The case if we can not find a second best socre that match our restriction
            disp('We do not have 2nd best score QQ');
            mkdir(['./video/',num2str(videoNum),'/normxcorrIter',num2str(iter)]);
            saveas(h(figNum) ,['./video/',num2str(videoNum),'/normxcorrIter',num2str(iter),'/',pathB(11:end-4),'__',pathA(11:end)]);
        end
    end

end
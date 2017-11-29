%image to be matched should be larger than the template
function [ypeak, xpeak, numOfIter, maxCoef, ratio, normMatrix, distToTop, distToLeft] = cropStreetView(template ,A, iter, scale)
    %If nothing is matched, then the following will be returned
    ypeak =  -1; xpeak = -1; numOfIter = 0; maxCoef = 0.0; ratio = 0.0; normMatrix = 0.0; 
    %initialize bounds for desired normzcorr area
    left = 0; right = 0; top = 0; bot = 0;
    desiredArea = 0.0;
    
    
    r1 = (size(template,1)/size(A,1));
    r2 = (size(template,2)/size(A,2));
    initSize =  double(max (r1,r2))  ; 
    if initSize ==0
        initSize = 1.0;
    end

    %%For MATLAB API
    A = imresize(A, initSize);   
%%%%%%Pre-operation before normxcorr for UBC's code: Zero Padding
% if zero > 0
%     temp = imresize(A, initSize);   
%     
%     A = zeros(size(temp,1)+2*size(template,1) ,size(temp,2)+2*size(template,2) );
%     A(size(template,1)+1:size(template,1)+size(temp,1) , size(template,2)+1:size(template,2)+size(temp,2)) = temp;
% else
%     A = imresize(A, initSize);   
% end
    %%%%%%End for UBC
    
    for i=1:iter
    
        c = normxcorr2(template,A); % MATLAB original API        

        left = int16(0.7 * size(template,2)); right = int16(size(A,2) + 0.3* size(template,2));
        top = int16(0.7 * size(template, 1)); bot = int16(size(A,1) - 0.2 * ( size(A,1) - size(template,1)));
        % ONLY Find max in my desire area.
        desiredArea = c(top:bot,left:right);
        [t, mi] = max(desiredArea);
        [coef, mj] = max(t);
        mi = mi(mj);
        
        %If the left border of the matching of this iteration resides in
        %the the area of A, then enter this condition
        if (maxCoef < coef)% && (mj - size(template,2)/2 < size(A,2) )%&&(mi - size(template,1)/2 < size(A,1) )
            normMatrix = desiredArea;
            maxCoef = coef;
            numOfIter = i;
            xpeak = mj + left ;
            ypeak = mi + top;
            ratio = initSize * (scale)^i;
            distToTop = top; 
            distToLeft = left;
        end
        
        %After each iteration, the image should be magnified by the scale.
        A = imresize(A, scale);
       
    end    
%     figure, surf(c), shading flat

end
%     subplot(224) ,imagesc(A);hold on; 
%     extWid = size(B,2)*0.05;
%     extHit = size(B,1)*0.05;
%     for i=1:3
%         
%         leftR = [max(xmin(i)- extWid,1), xmin(i)];
%         
%         rightR = [xmin(i)+ wid(i), min(xmin(i) + wid(i) + extWid,size(B,2))];
%         upR = [max(1,ymin(i) - extHit), ymin(i)];
%         downR=[ymin(i), min(ymin(i) + len(i) + extHit, size(B,1))];
%         % extent left
%         pts1 = reshape(bnnp(ymin(i): ymin(i) + len(i), leftR(1):leftR(2), 1),1,[]);
%         pts1(2,:) = reshape(bnnp(ymin(i): ymin(i) + len(i), leftR(1):leftR(2), 2),1,[]);
% %         pts1 = unique(pts1','rows')';
%         
%         [cor1,cor2] = meshgrid(leftR(1): leftR(2), ymin(i): ymin(i)+len(i));
%         
%         pts2 = [cor1(:)';cor2(:)']; pts2(3,:) = 1;               
%         pts1 = double([pts1;ones(1,size(pts1,2))]);        
%         [~,inlierIdx]=ransac1(pts1,pts2,coef,@estimateRigidTransform,@calcDist);
%         pts1(3,:) = [];
%         if i==1            
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'r');
%         elseif i==2
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'g');
%         else
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'w');
%         end
%         %% optional
%         %up
%         pts1 = reshape(bnnp( upR(1):upR(2), xmin(i):xmin(i)+wid(i), 1),1,[]);
%         pts1(2,:) = reshape(bnnp(upR(1):upR(2), xmin(i):xmin(i)+wid(i), 2),1,[]);
%         [cor1,cor2] = meshgrid( xmin(i):xmin(i)+wid(i),upR(1):upR(2));
%         
%         pts2 = [cor1(:)';cor2(:)']; pts2(3,:) = 1;               
%         pts1 = double([pts1;ones(1,size(pts1,2))]);        
%         [~,inlierIdx]=ransac1(pts1,pts2,coef,@estimateRigidTransform,@calcDist);
%         pts1(3,:) = [];
%         if i==1            
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'r');
%         elseif i==2
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'g');
%         else
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'w');
%         end
%         %right
%         pts1 = reshape(bnnp(ymin(i): ymin(i) + len(i), rightR(1):rightR(2), 1),1,[]);
%         pts1(2,:) = reshape(bnnp(ymin(i): ymin(i) + len(i), rightR(1):rightR(2), 2),1,[]);
%         [cor1,cor2] = meshgrid(rightR(1):rightR(2),ymin(i): ymin(i) + len(i));
%         
%         pts2 = [cor1(:)';cor2(:)']; pts2(3,:) = 1;               
%         pts1 = double([pts1;ones(1,size(pts1,2))]);        
%         [~,inlierIdx]=ransac1(pts1,pts2,coef,@estimateRigidTransform,@calcDist);
%         pts1(3,:) = [];
%         if i==1            
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'r');
%         elseif i==2
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'g');
%         else
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'w');
%         end
%         %down
%         pts1 = reshape(bnnp(downR(1):downR(2), xmin(i):xmin(i)+wid(i), 1),1,[]);
%         pts1(2,:) = reshape(bnnp(downR(1):downR(2), xmin(i):xmin(i)+wid(i), 2),1,[]);
%         [cor1,cor2] = meshgrid( xmin(i):xmin(i)+wid(i),downR(1):downR(2));
%         
%         pts2 = [cor1(:)';cor2(:)']; pts2(3,:) = 1;               
%         pts1 = double([pts1;ones(1,size(pts1,2))]);        
%         [~,inlierIdx]=ransac1(pts1,pts2,coef,@estimateRigidTransform,@calcDist);
%         pts1(3,:) = [];
%         if i==1            
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'r');
%         elseif i==2
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'g');
%         else
%             scatter(pts1(1,inlierIdx),pts1(2,inlierIdx),2,'w');
%         end
%                
%     end
%     hold off; 
function [blockedMat4x4,newdimension]=blocking4x4fromnxn(inputMatrix)
%% *blocking4x4fromnxn()*
% This function is responsible for dividing the input Matrix (2D) into 4x4
% blocks.
%% *Input Parameters*
% _*inputMatrix*_: it is the input two matrix of normally image.
%% *Output Parameters*
% _*blockedMat4x4*_: This is the blocked 4x4 matrix making 3-D array of
% multiple entries of 4x4 blocks
% * _newdimension_ *: This is a new dimensions of the resized image if it
% not of the multiples of 4x4



nopage=1; p=1;q=1;%count=0;
dimen=size(inputMatrix);

if (mod(dimen(1),4)==0)&&(mod(dimen(2),4)==0)
    newdimension=dimen;
else
    newdimension=[dimen(1)+(4-mod(dimen(1),4)) dimen(2)+(4-mod(dimen(2),4))];
end

blockedMat4x4=double(zeros(4,4,ceil((newdimension(1)*newdimension(2))/(4*4))));
resInputMatrix=imresize(inputMatrix,newdimension);
for i=1:4:newdimension(1)
    for j=1:4:newdimension(2)
        for ii=i:i+3
            for jj=j:j+3
                
                blockedMat4x4(p,q,nopage)=resInputMatrix(ii,jj);
                
                if ((mod(p,4)==0)&&(mod(q,4)==0))
                    p=1;
                    q=1;
                    nopage=nopage+1;
                elseif mod(q,4)==0
                    p=p+1;
                    q=1;
                else
                    q=q+1;
                end
                
            end
        end
    end
end

end
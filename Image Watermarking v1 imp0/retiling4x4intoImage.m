function [resizedImage]=retiling4x4intoImage(blockedMatrix,sizeOfretileDimen_new,oldDimension_original)
%% *retiling4x4intoImage*
% This is for retiling the 4x4 block matrices into a 2D array for image
% 
%% *Input Parameters*
% 
% * *_blockedMatrix:_* This is the 4x4 3-D array or 4x4 blocks, like 4x4xN
% * *_sizeOfretileDimen_new:_* This is the size of the resized matrix which was
% changed in blocking procedure. It is the new dimension which fits
% accoding to the 4x4 blocking procedure
% * *_oldDimension_original:_* This is the actual size of the 2D array which is
% required to be resized. It was before the blocking procedure.
%%
% 
%% *Output Parameters:*
% 
% * *_resizedImage:_* This is the output 2D array which was retiled and resized
% according the old dimension.
nopage=1; p=1;q=1;

%count=0;
% blockedMat=zeros(4,4,(dimen(1)*dimen(2))/(4*4));

outputMatrix=double(zeros(sizeOfretileDimen_new));
for i=1:4:sizeOfretileDimen_new(1)
    for j=1:4:sizeOfretileDimen_new(2)
        for ii=i:i+3
            for jj=j:j+3
                                
                outputMatrix(ii,jj)=blockedMatrix(p,q,nopage);
                
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

resizedImage=imresize(outputMatrix,oldDimension_original);
end
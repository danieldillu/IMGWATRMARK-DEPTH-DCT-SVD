function [u_comp,s_comp,v_comp,singularValueComp]=svdTransform(inputMatrix3d4x4)
%% svdTransform() Function
% It is the SVD (Singular Value Decomposition) transformation of a input
% 3-D array, using the built-in function svd(). It also returns the largest
% singular values, which is the first value of S-component.
%% Input Parameter includes:
% * _inputMatrix3d4x4_ , takes an input 3-D array of nxn matrix (for eg.
% 4x4), having l number of such matrix.
%% Output Parameters includes:
% # _u_comp_ , it is the U-component of one of the decomposed matrix. It is a
% orthogonal matrix. Actually, it the 3-D array of such matrices.
% # _s_comp_ , it is the S-component of the decomposed matrix. It is,
% actually, a diagonal matrix. Also, it is a 3-D array of such matrices.
% # _v_comp_ , it is also another component, similar to u_comp.
% # _singularValueComp_ , it is the 4x4xn array of largest singular values.

%% Matlab Code:

ind=size(inputMatrix3d4x4);
tempx=double(inputMatrix3d4x4);
u_comp=double(zeros(ind));
s_comp=double(zeros(ind));
v_comp=double(zeros(ind));
singularValueComp=double(zeros(ind(1),ind(2),ceil(ind(3)/(ind(1)*ind(2)))));
p=1;q=1;page2=1;
if ind(1)==ind(2)
    for nopage=1:ind(3)
        tt(:,:)=tempx(:,:,nopage);
        [u,s,v]=svd(tt);
        u_comp(:,:,nopage)=u;
        s_comp(:,:,nopage)=s;
        v_comp(:,:,nopage)=v;
    end
    
    for i=1:ind(3)
        singularValueComp(p,q,page2)=s_comp(1,1,i);
        
        if (mod(p,4)==0)&&(mod(q,4)==0)
            p=1;q=1;page2=page2+1;
        elseif mod(q,4)==0
            p=p+1;
            q=1;
        else
            q=q+1;
        end
    end
else
    fprintf('Dimensions in the SVD BOX does not match\n');
    return;
end

end
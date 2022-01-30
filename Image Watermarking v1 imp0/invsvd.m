function [s_mod_comp,imgblock4x4]=invsvd(indct,U_comp,S_comp,V_comp)
%% invsvd() Function
% This function take as four input and calculates inverse SVD.
%% The input values are:
% # _indct_ , modified Inverse DCT Value 3-D array of dimensions 4x4x1024
% after applying DCT modification part.
% # _U_comp_ , U-component 3-D array of dimension 4x4x16384 of 4x4 orthogonal
% # _S_comp_ , S-Component 3-D array of dimension 4x4x16384 of 4x4 diagonal
% # _V_comp_ , V-Component 3-D array of dimension 4x4x16384 of 4x4 diagonal
%% The Output Values includes:
% # _s_mod_comp_ , Modified S-Component after modified DCT values.
% # _imgblock4x4_ , Image blocks 4x4 matrix formed after applying inverse SVD
% (Singular Value Decomposition)

%% Inverse Singular Value Decomposition
% Inverse SVD is the reverse transformation of the matrix after the SVD is
% applied.
% For calculating the Inverse SVD, let U,S and V respectively.
% *A=U*S*V';*
% A is reconstructed matrix from U,S and V component.
%% MATLAB Codes:

s_mod_comp=S_comp;
sz=size(S_comp);szdc=size(indct);
p=1;q=1;page2=1;
imgblocks=double(zeros(sz));
if szdc(1)==szdc(2)
    for i=1:sz(3)
        
        s_mod_comp(1,1,i)=indct(p,q,page2);
       
        if(mod(p,4)==0)&&(mod(q,4)==0)
            p=1;
            q=1;
            page2=page2+1;
        elseif mod(q,4)==0
            p=p+1;
            q=1;
        else
            q=q+1;
        end
        
    end

    for i=1:sz(3)
        
        ut=U_comp(:,:,i);
        vt=V_comp(:,:,i);
        st=s_mod_comp(:,:,i);
        
        imgtmp=ut*st*vt';
        
        imgblocks(:,:,i)=imgtmp;
        
    end
else
    fprintf('Dimension in the INVSVD doesnot match\n');
    return;
end

imgblock4x4=imgblocks;
% xlswrite('watermarked\Report Excel\Inverse SVD Test.xlsx',ind);
% fprintf('File exported: ~\\watermarked\\Report Excel\\Inverse SVD Test.xlsx \n');
end
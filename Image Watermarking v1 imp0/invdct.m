function [idcttemp]=invdct(dctValue)
%% invdct()Function
% This function calculates the inverse DCT of 3-D array, which is actually
% a nxn matrix having M entries of matrices. There is no new function
% defined but it is a extended form of idct() built-in function.
%% The Input Parameter include:
% * _dctValue_, is a 3-D array of matrices of dimension nxn having M such
% entries.

%% The Output Parameter are:
% * _idcttemp_, is a calculate inverse DCT entries, 3-D array of matrices
% of nxnxM.

%% MATLAB Codes:

dimen=size(dctValue);
idcttemp=zeros(dimen);
if dimen(1)==dimen(2)
    % slice=zeros(4,4);
    for i=1:dimen(3)
        slice=dctValue(:,:,i);
        tmp1=idct(slice);
        idcttemp(:,:,i)=tmp1(:,:);
    end
else
    fprintf('Dimensions in the INVDCT doesnot match\n');
    return;
end
end
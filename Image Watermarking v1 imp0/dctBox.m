function [dcttemp] = dctBox( inputMatrix)
%% dctBox() Function
% It is a function for calculating the DCT of a 3-D Array of size or eg. 4x4x1024.
% This function is not a special function but the derivation of dct().

%% The Input Parameters includes:
% * InputMatrix, it takes an input of a 3-D array and calculates DCT and
% returns an output matrix.
%% The Output Parameter includes:
% * dcttemp, it outputs a 3-D array, DCT calculated.

%% Matlab Code:

sz=size(inputMatrix);
if sz(1)==sz(2)
    dcttemp=zeros(sz);
    for i=1:sz(3)
        temp=inputMatrix(:,:,i);
        dtemp=dct(temp);
        dcttemp(:,:,i)=dtemp;
    end
else
    fprintf('Dimension in DCT box doesnot match\n');
end
end


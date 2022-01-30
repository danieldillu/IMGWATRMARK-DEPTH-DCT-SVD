function []=tiff_writer(ImageMatrix,FileName)
% if ~isa(ImageMatrix,'uint16')
%     ImageMatrix1=uint16(ImageMatrix);
% else
%     ImageMatrix1=ImageMatrix;
% end

 A=single(ImageMatrix);
% if exist(FileName,'file')==2
%     t = Tiff('test.tif', 'w');
% else
%     t = Tiff('test.tif', 'w');
% end
t = Tiff(FileName, 'w'); 
tagstruct.ImageLength = size(A, 1); 
tagstruct.ImageWidth = size(A, 2); 
tagstruct.Compression = Tiff.Compression.None; 
tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP; 
tagstruct.Photometric = Tiff.Photometric.MinIsBlack; 
tagstruct.BitsPerSample = 32; 
tagstruct.SamplesPerPixel = 1; 
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky; 
t.setTag(tagstruct); 
t.write(A); 
t.close();
end
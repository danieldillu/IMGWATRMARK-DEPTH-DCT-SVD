clear all;
partialOutputURL='..\temps\Image Watermarking v1 imp0';
% Output Folder for Watermarked images
if exist('..\temps\Image Watermarking v1 imp0\TIFF','dir')==7
    %     nothing
else
    mkdir('..\temps\Image Watermarking v1 imp0\TIFF');
end

% Output Folder for JPEG Watermarked images
if exist('..\temps\Image Watermarking v1 imp0\JPEG_IMG','dir')==7
    %     nothing
else
    mkdir('..\temps\Image Watermarking v1 imp0\JPEG_IMG');
end

% Output Folder for Extracted Watermark images
if exist('..\temps\Image Watermarking v1 imp0\EXTW')==7
    %     nothing
else
    mkdir('..\temps\Image Watermarking v1 imp0\EXTW');
end

isWatermarkBinary=input('Is Watermark Binary?? 1 for yes and 0 for no? ');

alphaValuebgfg=[0.95 0.99];

watermarkURL='..\Image Set\watermark images\logo\logo1.png';
HIFURL='..\Image Set\Grayscale Image Set';
GTFURL='..\Image Set\Grayscale GT Image';
WDFURL=strcat(partialOutputURL,'\TIFF');
JPEGIFURL=strcat(partialOutputURL,'\JPEG_IMG');



HIfolder=dir(HIFURL);
GTfolder=dir(GTFURL);
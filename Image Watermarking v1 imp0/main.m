%% Main (Watermark Embedding / Extraction / Attacked analysis 
% This script is combination of all the other scripts which has
% Watermark embedding, extraction as well as attacks applied as generated
% as reports of each.
tic
% Embedding process.
Watrmarking_for_ImageSet;
clear all;
% Extraction process
WTExtraction_for_Image_set;
clear all;
% Attacked applied on watermarked images and impact of it on watermark is
% seen
Attacked;
clear all;
toc;
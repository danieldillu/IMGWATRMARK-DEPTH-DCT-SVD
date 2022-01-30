clc;  init;
tic

disp('Watermark Embedding Process:');
disp('Original Watermark Image: <a href="matlab:imshow(rgb2gray(watrmarkImg),[])" >logo1.png</a>(Dimensions are not as per use)');
disp('_______________________________________________________________________');

watrmarkImg=rgb2gray(imread(watermarkURL));

pk=1;



% HIFitem=size(HIfolder);
for findex=3:size(HIfolder,1)
    fprintf('%d. Processing:%s\n',findex-2,HIfolder(findex).name);
    if strcmp(HIfolder(findex).name,GTfolder(findex).name)
        [hpathstr,hname,hext] = fileparts(HIfolder(findex).name);
        [gtpathstr,gtname,gtext] = fileparts(GTfolder(findex).name);
        clear gtpathstr gtname hpathstr;
        if strcmp(hext,'.png')&& strcmp(gtext,'.png')
            hiurl=strcat(HIFURL,'\',HIfolder(findex).name);
            disp(strcat('   -Host Image: <a href="matlab:winopen(''',hiurl,''')" > ',HIfolder(findex).name,'</a>'));
            gturl=strcat(GTFURL,'\',GTfolder(findex).name);
            disp(strcat('   -GT Image: <a href="matlab:winopen(''',gturl,''')" > ',GTfolder(findex).name,'</a>'));
            hostImage=imread(hiurl);
            gtImage=imread(gturl);
            
            OutputFilePath=strcat(partialOutputURL,'\TIFF\',hname,'.tif');
            
            if isWatermarkBinary
                [watermarkedImage]=WEmbedding(hostImage,gtImage,watrmarkImg,alphaValuebgfg);
                %                 disp('Function is not yet called!');
                %                 return;
            else
                %                 watermarkedImage=WEmbeding2ver1(hostImage,gtImage,watrmarkImg,isWatermarkBinary,alphaValuebgfg);
                                watermarkedImage=WEmbeding2(hostImage,gtImage,watrmarkImg,isWatermarkBinary,alphaValuebgfg);

            end
            
            %                         testModuleEmbedded;
            %             watermarkedImage=WEmbeding(hostImage,gtImage,watrmarkImg,alphaValuebgfg);
            
            tiff_writer(watermarkedImage,OutputFilePath);
            disp(strcat('   -Watermarked Image: <a href="matlab:tiffViewer(''',OutputFilePath,''')" >',hname,'.tiff</a>'));
            %             figure,imshow(watermarkedImage,[]);
            peaksnr(pk,1)=findex;
            [peaksnr(pk,2),~]=psnr(double(watermarkedImage),double(hostImage),maxiElement(hostImage));
            disp(strcat('   PSNR Value is:',num2str(peaksnr(pk,2))));
            ssimvalwd(pk,1)=findex;
            [ssimvalwd(pk,2),~]=ssim(double(watermarkedImage),double(hostImage));
            disp(strcat('   SSIM Value is:',num2str(ssimvalwd(pk,2))));
            pk=pk+1;
            %
            %                         if pk==2
            %                             return;
            %                         end
            
        else
            error('Format of the Image is not match')
        end
        
    else
        
    end
    %     HIfolder(findex).name
    %     GTfolder(findex).name
    disp('_______________________________________________________________________');
end
if isWatermarkBinary
    xlswrite(strcat(partialOutputURL,'\PSNR_Measure_BIN.xlsx'),peaksnr);
    disp('  PSNR Report File of Watermarked Images: <a href="matlab:winopen(strcat(partialOutputURL,''\PSNR_Measure_BIN.xlsx''))">PSNR_Measure_BIN.xlsx</a>');
    xlswrite(strcat(partialOutputURL,'\SSIM_Measure_BIN.xlsx'),ssimvalwd);
    disp('  SSIM Report File of Watermarked Images: <a href="matlab:winopen(strcat(partialOutputURL,''\SSIM_Measure_BIN.xlsx''))">SSIM_Measure_BIN.xlsx</a>');
else
    xlswrite(strcat(partialOutputURL,'\PSNR_Measure.xlsx'),peaksnr);
    disp('  PSNR Report File of Watermarked Images: <a href="matlab:winopen(strcat(partialOutputURL,''\PSNR_Measure.xlsx''))">PSNR_Measure.xlsx</a>');
    xlswrite(strcat(partialOutputURL,'\SSIM_Measure.xlsx'),ssimvalwd);
    disp('  SSIM Report File of Watermarked Images: <a href="matlab:winopen(strcat(partialOutputURL,''\SSIM_Measure.xlsx''))">SSIM_Measure.xlsx</a>');
end
toc
disp('_______________________________________________________________________');
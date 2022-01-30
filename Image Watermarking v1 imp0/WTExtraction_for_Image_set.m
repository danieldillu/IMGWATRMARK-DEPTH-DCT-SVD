init;
tic
disp('Watermark Extraction Process:');

WDfolder=dir(WDFURL);

watrmarkImg=rgb2gray(imread(watermarkURL));
disp('Original Watermark: <a href="matlab:imshow(watrmarkImg)" > logo1 </a>');
disp('__________________________________________________________________');

pk=1;

HIFitem=size(HIfolder);

ssimvalwdr=double(zeros(size(HIfolder,1)-2,2));
meansVal=double(zeros(size(HIfolder,1)-2,2));

for findex=3:HIFitem(1)
    fprintf('%d Processing:%s\n',findex-2,WDfolder(findex).name);
    [hpathstr,hname,hext] = fileparts(HIfolder(findex).name);
    [gtpathstr,gtname,gtext] = fileparts(GTfolder(findex).name);
    [wdpathstr,wdname,wdext] = fileparts(WDfolder(findex).name);
    if strcmp(HIfolder(findex).name,GTfolder(findex).name)&&strcmp(hname,wdname)
        
        if strcmp(hext,'.png')&& strcmp(gtext,'.png')&&strcmp(wdext,'.tif')
            hiurl=strcat(HIFURL,'\',HIfolder(findex).name);
            disp(strcat('   -Host Image: <a href="matlab:winopen(''',hiurl,''')">',HIfolder(findex).name,'</a>'));
            gturl=strcat(GTFURL,'\',GTfolder(findex).name);
            disp(strcat('   -GT Image: <a href="matlab:winopen(''',gturl,''')">',GTfolder(findex).name,'</a>'));
            wdurl=strcat(WDFURL,'\',WDfolder(findex).name);
            disp(strcat('   -Watermarked Image: <a href="matlab:tiffViewer(''',wdurl,''')">',WDfolder(findex).name,'</a>'));
            
            ssimvalwdr(pk,1)=findex;
            meansVal(pk,1)=findex;
            
            hostImage=imread(hiurl);
            gtImage=imread(gturl);
            wdImage=imread(wdurl);
            
            if isWatermarkBinary
                [recoveredWImage]=WExtracted(wdImage,hostImage,gtImage,alphaValuebgfg);
                %                 disp('Function for binary image is not defined');
                %                 return;
            else
                %                 [recoveredWImage]=WExtracted(wdImage,hostImage,gtImage,alphaValuebgfg);
                [recoveredWImage]=WExtraction2(wdImage,hostImage,gtImage,alphaValuebgfg);
            end
            %             [recoveredWImage]=WExtraction2(wdImage,hostImage,gtImage,alphaValuebgfg);
            %             testModuleExtract;
            %             testModuleExtrn2;
            %             figure,imshow(recoveredWImage,[]);
            
            tiff_writer(recoveredWImage,strcat(partialOutputURL,'\EXTW\Ext_',hname,'.tif'));
            disp(strcat('   -Extracted Watermark: <a href="matlab:tiffViewer(strcat(partialOutputURL,''\EXTW\Ext_',hname,'.tif''))" >Ext_',hname,'.tif</a>'));
            if isWatermarkBinary
                [ssimvalwdr(pk,2),~]=ssim(double(recoveredWImage),double(im2bw(imresize(watrmarkImg,size(recoveredWImage)),graythresh(imresize(watrmarkImg,size(recoveredWImage))))));
                disp(strcat(' SSIM Value is:',num2str(ssimvalwdr(pk,2))));
                [meansVal(pk,2)]=immse(double(recoveredWImage),double(im2bw(imresize(watrmarkImg,size(recoveredWImage)),graythresh(imresize(watrmarkImg,size(recoveredWImage))))));
                disp(strcat(' MSE Value is:',num2str(meansVal(pk,2))));
            else
                [ssimvalwdr(pk,2),~]=ssim(double(recoveredWImage),double(imresize(watrmarkImg,size(recoveredWImage))));
                disp(strcat(' SSIM Value is:',num2str(ssimvalwdr(pk,2))));
                [meansVal(pk,2)]=immse(double(recoveredWImage),double(imresize(watrmarkImg,size(recoveredWImage))));
                disp(strcat(' MSE Value is:',num2str(meansVal(pk,2))));
            end
            disp('__________________________________________________________________');
            pk=pk+1;
            
            
            %                         if pk==2
            %                             return;
            %                         end
        else
            error('Format of the file %s is not image.',HIfolder(findex).name);
        end
    end
end
if isWatermarkBinary
    xlswrite(strcat(partialOutputURL,'\SSIM_Measure_Of_WI_BIN.xlsx'),ssimvalwdr);
    disp('  SSIM Report File of Recovered Watermark: <a href="matlab:winopen(strcat(partialOutputURL,''\SSIM_Measure_Of_WI_BIN.xlsx''))">SSIM_Measure_Of_WI_BIN.xlsx </a>');
    xlswrite(strcat(partialOutputURL,'\MSE_Measure_of_WI_BIN.xlsx'),meansVal);
    disp('  MSE Report File of Recovered Watermark: <a href="matlab:winopen(strcat(partialOutputURL,''\MSE_Measure_of_WI_BIN.xlsx''))">MSE_Measure_of_WI_BIN.xlsx </a>');
else
    xlswrite(strcat(partialOutputURL,'\SSIM_Measure_Of_WI.xlsx'),ssimvalwdr);
    disp('  SSIM Report File of Recovered Watermark: <a href="matlab:winopen(strcat(partialOutputURL,''\SSIM_Measure_Of_WI.xlsx''))">SSIM_Measure_Of_WI.xlsx </a>');
    xlswrite(strcat(partialOutputURL,'\MSE_Measure_of_WI.xlsx'),meansVal);
    disp('  MSE Report File of Recovered Watermark: <a href="matlab:winopen(strcat(partialOutputURL,''\MSE_Measure_of_WI.xlsx''))">MSE_Measure_of_WI.xlsx </a>');
end
toc
disp('__________________________________________________________________');
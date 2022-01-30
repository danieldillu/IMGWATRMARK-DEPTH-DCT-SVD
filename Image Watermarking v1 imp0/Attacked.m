%% Image Processing Attacks
% The Image processing attacks are applied here. Attacks includes AWGN,
% Median Filtering, Scaling Attack and JPEG attacks.

%% MATLAB Codes with different Sections:

init;
tic

WDfolder=dir(WDFURL);

watrmarkImg=imread(watermarkURL);
wtrm=imresize(rgb2gray(watrmarkImg),[128 128]);
disp('Original Watermark Image: <a href="matlab:imshow(wtrm,[])">logo1.png</a> (2x zoomed)');

% awgnparam=[10*log10(0.01) 10*log10(0.05) 10*log10(0.1) 10*log10(0.15)];
awgnparam=[0.01 0.05 0.1 0.15];
scalingparam=[0.10 0.25 0.50 0.75 1.25];
medfparam=[3 3;5 5;7 7;9 9;11 11];

ssimvalwdr=double(zeros(size(HIfolder,1)-2,size(awgnparam,2)+size(scalingparam,2)+size(medfparam,1)+1));
meansVal=double(zeros(size(HIfolder,1)-2,size(awgnparam,2)+size(scalingparam,2)+size(medfparam,1)+1));
ssimvalwdrjp=double(zeros(size(HIfolder,1)-2,(100/5)+1));
meansValjp=double(zeros(size(HIfolder,1)-2,(100/5)+1));

ii=1;jj=1;kk=1;pk=1;
% berawgn=zeros(21,8);a=zeros([64,5]);bermf=zeros(21,10);ab=zeros([64,5]);

% For JPEG FILES
for i2=5:5:100
    if exist(strcat(JPEGIFURL,'\',int2str(i2)),'dir')==7
        % delete(strcat('\watermarked\JPEG2\',int2str(i2),'\*.png'));
    else
        mkdir(JPEGIFURL,int2str(i2));
    end
end


HIFitem=size(HIfolder);
for findex=3:HIFitem(1)
    fprintf('%d. Processing:%s\n',findex-2,WDfolder(findex).name);
    [hpathstr,hname,hext] = fileparts(HIfolder(findex).name);
    [gtpathstr,gtname,gtext] = fileparts(GTfolder(findex).name);
    [wdpathstr,wdname,wdext] = fileparts(WDfolder(findex).name);
    if strcmp(HIfolder(findex).name,GTfolder(findex).name)&&strcmp(hname,wdname)
        
        if strcmp(hext,'.png')&& strcmp(gtext,'.png')&&strcmp(wdext,'.tif')
            hiurl=strcat(HIFURL,'\',HIfolder(findex).name);
            gturl=strcat(GTFURL,'\',GTfolder(findex).name);
            wdurl=strcat(WDFURL,'\',WDfolder(findex).name);
            
            disp(strcat('    ->Host Image: <a href="matlab:tiffViewer(''',hiurl,''')">',HIfolder(findex).name,'</a>'));
            hostImage=imread(hiurl);
            disp(strcat('    ->GT Image: <a href="matlab:tiffViewer(''',gturl,''')">',GTfolder(findex).name,'</a>'));
            gtImage=imread(gturl);
            disp(strcat('    ->Watermarked Image: <a href="matlab:tiffViewer(''',wdurl,''')">',WDfolder(findex).name,'</a>'));
            wdImage=imread(wdurl);
            if isWatermarkBinary
                [recoveredWImage]=WExtracted(wdImage,hostImage,gtImage,alphaValuebgfg);
            else
                [recoveredWImage]=WExtraction2(wdImage,hostImage,gtImage,alphaValuebgfg);
            end            
            
            
            ssimvalwdr(pk,1)=findex;
            meansVal(pk,1)=findex;
            ssimvalwdrjp(pk,1)=findex;
            meansValjp(pk,1)=findex;
            %% AWGN Attack
            disp('   |_AWGN Attack');
            for awgnI=1:size(awgnparam,2)
                %                 disp(awgnparam(awgnI));
                awgn_res=awgn(wdImage,awgnparam(awgnI));
                if isWatermarkBinary
                    watermark2dy20=WExtracted(awgn_res,hostImage,gtImage,alphaValuebgfg);
                else
                    watermark2dy20=WExtraction2(awgn_res,hostImage,gtImage,alphaValuebgfg);
                end
                
                if isWatermarkBinary
                    [ssimvalwdr(pk,awgnI+1),~]=ssim(double(watermark2dy20),double(im2bw(imresize(rgb2gray(watrmarkImg),size(watermark2dy20)),graythresh(imresize(rgb2gray(watrmarkImg),size(watermark2dy20))))));
                    [meansVal(pk,awgnI+1)]=immse(double(watermark2dy20),double(im2bw(imresize(rgb2gray(watrmarkImg),size(watermark2dy20)),graythresh(imresize(rgb2gray(watrmarkImg),size(watermark2dy20))))));
                    [~,biterValue(pk,awgnI+1)]=biterr(double(watermark2dy20),double(im2bw(imresize(rgb2gray(watrmarkImg),size(watermark2dy20)),graythresh(imresize(rgb2gray(watrmarkImg),size(watermark2dy20))))));
                else
                    [ssimvalwdr(pk,awgnI+1),~]=ssim(double(watermark2dy20),double(imresize(rgb2gray(watrmarkImg),size(watermark2dy20))));
                    [meansVal(pk,awgnI+1)]=immse(double(watermark2dy20),double(imresize(rgb2gray(watrmarkImg),size(watermark2dy20))));
                end
            end
            
            %END AWGN
            
            %% Median Filter
            disp('   |_Median Filter Attack');
            for mdfI=1:size(medfparam,1)
                %                 disp(medfparam(mdfI,:));
                medfd33 = medfilt2(wdImage, medfparam(mdfI,:));
                if isWatermarkBinary
                    temp=WExtracted(medfd33,hostImage,gtImage,alphaValuebgfg);
                else
                    temp=WExtraction2(medfd33,hostImage,gtImage,alphaValuebgfg);
                end
                
                if isWatermarkBinary
                    [ssimvalwdr(pk,mdfI+5),~]=ssim(double(temp),double(im2bw(imresize(rgb2gray(watrmarkImg),size(temp)),graythresh(imresize(rgb2gray(watrmarkImg),size(temp))))));
                    [meansVal(pk,mdfI+5)]=immse(double(temp),double(im2bw(imresize(rgb2gray(watrmarkImg),size(temp)),graythresh(imresize(rgb2gray(watrmarkImg),size(temp))))));
                    [~,biterValue(pk,mdfI+5)]=biterr(double(temp),double(im2bw(imresize(rgb2gray(watrmarkImg),size(temp)),graythresh(imresize(rgb2gray(watrmarkImg),size(temp))))));
                else
                    [ssimvalwdr(pk,mdfI+5),~]=ssim(double(temp),double(imresize(rgb2gray(watrmarkImg),size(temp))));
                    [meansVal(pk,mdfI+5)]=immse(double(temp),double(imresize(rgb2gray(watrmarkImg),size(temp))));
                end
            end
            
            % END Median Filter
            
            %% Scaling Attack
            disp('   |_Scaling Attack');
            for scalI=1:size(scalingparam,2)
                %                 disp(scalingparam(scalI));
                imrs10=imresize(wdImage,scalingparam(scalI));
                if isWatermarkBinary
                    temp1=WExtracted(imrs10,hostImage,gtImage,alphaValuebgfg);
                else
                    temp1=WExtraction2(imrs10,hostImage,gtImage,alphaValuebgfg);
                end
                
                if isWatermarkBinary
                    [ssimvalwdr(pk,scalI+10),~]=ssim(double(temp1),double(im2bw(imresize(rgb2gray(watrmarkImg),size(temp1)),graythresh(imresize(rgb2gray(watrmarkImg),size(temp1))))));
                    [meansVal(pk,scalI+10)]=immse(double(temp1),double(im2bw(imresize(rgb2gray(watrmarkImg),size(temp1)),graythresh(imresize(rgb2gray(watrmarkImg),size(temp1))))));
                    [~,biterValue(pk,scalI+10)]=biterr(double(temp1),double(im2bw(imresize(rgb2gray(watrmarkImg),size(temp1)),graythresh(imresize(rgb2gray(watrmarkImg),size(temp1))))));
                else
                    [ssimvalwdr(pk,scalI+10),~]=ssim(double(temp1),double(imresize(rgb2gray(watrmarkImg),size(temp1))));
                    [meansVal(pk,scalI+10)]=immse(double(temp1),double(imresize(rgb2gray(watrmarkImg),size(temp1))));
                end
            end
            
            % END Scalng Filter
            
            %% JPEG Attack
            disp('   |_JPEG Attack');
            jpk=2;
            for jp1=5:5:100
                %                 disp(jp1);
                jpegFileURL=strcat(JPEGIFURL,'\',num2str(jp1),'\',hname,'.jpeg');
                imwrite(wdImage,jpegFileURL,'Quality',jp1);
                jpeg_attack=imread(jpegFileURL);
                if isWatermarkBinary
                    tempJP=WExtracted(jpeg_attack,hostImage,gtImage,alphaValuebgfg);
                else
                    tempJP=WExtraction2(jpeg_attack,hostImage,gtImage,alphaValuebgfg);
                end
                
                if isWatermarkBinary
                    [ssimvalwdrjp(pk,jpk),~]=ssim(double(tempJP),double(im2bw(imresize(rgb2gray(watrmarkImg),size(tempJP)),graythresh(imresize(rgb2gray(watrmarkImg),size(tempJP))))));
                    [meansValjp(pk,jpk)]=immse(double(tempJP),double(im2bw(imresize(rgb2gray(watrmarkImg),size(tempJP)),graythresh(imresize(rgb2gray(watrmarkImg),size(tempJP))))));
                    [~,biterValjp(pk,jpk)]=biterr(double(tempJP),double(im2bw(imresize(rgb2gray(watrmarkImg),size(tempJP)),graythresh(imresize(rgb2gray(watrmarkImg),size(tempJP))))));
                else
                    [ssimvalwdrjp(pk,jpk),~]=ssim(double(tempJP),double(imresize(rgb2gray(watrmarkImg),size(tempJP))));
                    [meansValjp(pk,jpk)]=immse(double(tempJP),double(imresize(rgb2gray(watrmarkImg),size(tempJP))));
                end
                jpk=jpk+1;
            end
            disp('________________________________________________________');
            % END JPEG
            pk=pk+1;
        end
    end
end
disp('_________________________ENDS___________________________');
if isWatermarkBinary
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\MSE_Report_of_Attacks_BIN.xlsx',meansVal);
    disp('MSE Report File: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\MSE_Report_of_Attacks_BIN.xlsx'')">MSE_Report_of_Attacks_BIN.xlsx</a>');
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\SSIM_Reprts_of_Attacks_BIN.xlsx',ssimvalwdr);
    disp('SSIM Report File: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\SSIM_Reprts_of_Attacks_BIN.xlsx'')">SSIM_Reprts_of_Attacks_BIN.xlsx</a>');
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\BER_Reprts_of_Attacks_BIN.xlsx',biterValue);
    disp('BER Report File: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\BER_Reprts_of_Attacks_BIN.xlsx'')">BER_Reprts_of_Attacks_BIN.xlsx</a>');
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\MSE_Report_of_Attacks_JPEG_BIN.xlsx',meansValjp);
    disp('MSE Report of JPEG Attack: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\MSE_Report_of_Attacks_JPEG_BIN.xlsx'')">MSE_Report_of_Attacks_JPEG_BIN.xlsx</a>');
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\SSIM_Report_of_Attacks_JPEG_BIN.xlsx',ssimvalwdrjp);
    disp('SSIM Report of JPEG Attack: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\SSIM_Report_of_Attacks_JPEG_BIN.xlsx'')">SSIM_Report_of_Attacks_JPEG_BIN.xlsx</a>');
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\BER_Report_of_Attacks_JPEG_BIN.xlsx',biterValjp);
    disp('BER Report of JPEG Attack: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\BER_Report_of_Attacks_JPEG_BIN.xlsx'')">BER_Report_of_Attacks_JPEG_BIN.xlsx</a>');
else
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\MSE_Report_of_Attacks.xlsx',meansVal);
    disp('MSE Report File: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\MSE_Report_of_Attacks.xlsx'')">MSE_Report_of_Attacks.xlsx</a>');
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\SSIM_Reprts_of_Attacks.xlsx',ssimvalwdr);
    disp('SSIM Report File: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\SSIM_Reprts_of_Attacks.xlsx'')">SSIM_Reprts_of_Attacks.xlsx</a>');
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\MSE_Report_of_Attacks_JPEG.xlsx',meansValjp);
    disp('MSE Report of JPEG Attack: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\MSE_Report_of_Attacks_JPEG.xlsx'')">MSE_Report_of_Attacks_JPEG.xlsx</a>');
    xlswrite('..\..\..\..\Project Trash\Image Watermarking V1\SSIM_Report_of_Attacks_JPEG.xlsx',ssimvalwdrjp);
    disp('SSIM Report of JPEG Attack: <a href="matlab:winopen(''..\..\..\..\Project Trash\Image Watermarking V1\SSIM_Report_of_Attacks_JPEG.xlsx'')">SSIM_Report_of_Attacks_JPEG.xlsx</a>');
end
toc

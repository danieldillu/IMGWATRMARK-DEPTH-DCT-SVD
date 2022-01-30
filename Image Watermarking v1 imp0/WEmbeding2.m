function [wdimage]=WEmbeding2(hostImage,gtImage,watermarkImage,isWatermarkBinary,alphaValuebgfg)
%% Checking the validity of the variables
% if yes 1 otherwise 0 for isWatermarkBinary

szHI=size(hostImage);
szGT=size(gtImage);

if szGT(1)==szHI(1) && szGT(2)==szHI(2)
    gtImage1=gtImage;
else
    gtImage1=imresize(gtImage,szHI);
end

%% Initialization of the variables
alphafg=alphaValuebgfg(2);
alphabg=alphaValuebgfg(1);

%% Pre-processing of Host Image
[icA,icH,icV,icD]=dwt2(hostImage,'Haar');
% [blockedMat4x4]=blocking4x4fromnxn(icA);
[blockedMat4x4,hnewdimen]=blocking4x4fromnxn(rounding10p10(icA));
[u_comp,s_comp,v_comp,singularValueComp]=svdTransform( blockedMat4x4);

%% GT Image pre-processing
[gticA,~,~,~]=dwt2(gtImage1,'Haar');
level=graythresh(gticA);
bwimage=im2bw(gticA,level);
alphavalue1=double(bwimage);
sz2=size(alphavalue1);
for i=1:sz2(1)
    for j=1:sz2(2)
        if bwimage(i,j)==1
            alphavalue1(i,j)=alphafg;
        else
            alphavalue1(i,j)=alphabg;
        end
    end
end
[alphagtblocked,~]=blocking4x4fromnxn(alphavalue1);

%% Watermark Image pre-processing
sz1=size(singularValueComp);
dimensionsOfWatermark=[ceil(sqrt(sz1(1)*sz1(2)*sz1(3))) ceil(sqrt(sz1(1)*sz1(2)*sz1(3)))];
imrestwr=imresize(watermarkImage,dimensionsOfWatermark);
if isWatermarkBinary
    imrestwr1=im2bw(imrestwr,graythresh(imrestwr));
else
    imrestwr1=imrestwr;
end
[blocked4x4wtr,~]=blocking4x4fromnxn(imrestwr1);
% dctvaluewtr=dctBox(blocked4x4wtr);
dctvaluewtr=blocked4x4wtr;

%% Watermark Intermediate Value Modification

sz3=size(singularValueComp);
modsingValue=double(zeros(sz3));
for i=1:sz3(3)
    for j=1:sz3(1)
        for k=1:sz3(2)
            
            alphat=alphagtblocked(j,k,i);
            antialfa=1-alphat;
            modsingValue(j,k,i)=(singularValueComp(j,k,i)*alphat)+(antialfa*dctvaluewtr(j,k,i));
            
        end        
    end
end

%% Post-processing

[~,img4r]=invsvd(modsingValue,u_comp,s_comp,v_comp);

recimgA=retiling4x4intoImage(img4r,hnewdimen,size(icA));
imagerec=idwt2(recimgA,icH,icV,icD,'Haar');

WatermarkPostProcessed=rounding10p10(imagerec);

%% Output
wdimage=WatermarkPostProcessed;
% wdimage=uint16(WatermarkPostProcessed.*10);
end
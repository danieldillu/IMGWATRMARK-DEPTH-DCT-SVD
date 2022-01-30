function [recoveredWImage]=WExtracted(watermarkedImage,hostImage,gtImage,alphaValuebgfg)
%% Checking Validality of the variables
szHI=size(hostImage);
szGT=size(gtImage);
szWD=size(watermarkedImage);

if szWD(1)==szHI(1) && szWD(2)==szHI(2)
    if szGT(1)==szHI(1) && szGT(2)==szHI(2)
        hostImage1=hostImage;
        gtImage1=gtImage;
    else
        hostImage1=imresize(hostImage,szWD);
        gtImage1=imresize(gtImage,szWD);
    end
else
    hostImage1=imresize(hostImage,szWD);
    gtImage1=imresize(gtImage,szWD);
end

%% Initialization of the variables
alphafg=alphaValuebgfg(2);
alphabg=alphaValuebgfg(1);

%% Host Image pre-processing
[icA1,~,~,~]=dwt2(hostImage1,'Haar');
icA=rounding10p10(icA1);
% [blockedMat4x4]=blocking4x4fromnxn(icA);
[blockedMat4x4,~]=blocking4x4fromnxn(icA);
[~,~,~,singularValueComp]=svdTransform(blockedMat4x4);
dctValuesofHost=dctBox(singularValueComp);

%% Ground Truth Image pre-processing
[gticA1,~,~,~]=dwt2(gtImage1,'Haar');
gticA=rounding10p10(gticA1);
level=graythresh(gticA);
bwimage=im2bw(gticA,level);
alphaValue=double(bwimage);
sz1=size(alphaValue);
for i=1:sz1(1)
    for j=1:sz1(2)
        if bwimage(i,j)==1
            alphaValue(i,j)=alphafg;
        else
            alphaValue(i,j)=alphabg;
        end
    end
end
[alpha3DArray,~]=blocking4x4fromnxn(alphaValue);

%% Watermarked Image pre-processing
[wdcA1,~,~,~]=dwt2(watermarkedImage,'Haar');
wdcA=rounding10p10(wdcA1);
% wdcAblock4x4=blocking4x4fromnxn(wdcA);
[wdcAblock4x4,~]=blocking4x4fromnxn(wdcA);
[~,~,~,wsingValue]=svdTransform(wdcAblock4x4);
wdctValueofWatrm=dctBox(wsingValue);

%% Watermark Extraction/Modification

sz2=size(dctValuesofHost);
imageAnalogus=double(zeros(sz2));
for i=1:sz2(1)
    for j=1:sz2(2)
        for k=1:sz2(3)
            alpha=alpha3DArray(i,j,k);
            temp=(wdctValueofWatrm(i,j,k)-(alpha*dctValuesofHost(i,j,k)))/(1-alpha);
            if temp<97
                imageAnalogus(i,j,k)=0;
            else
                imageAnalogus(i,j,k)=1;
            end
            %             dctWatermark(i,j,k);
        end
    end
end

% sz2=size(wsingValue);
% imageAnalogus=double(zeros(sz2));
% for i=1:sz2(1)
%     for j=1:sz2(2)
%         for k=1:sz2(3)
%             alpha=alpha3DArray(i,j,k);
%             temp=(wsingValue(i,j,k)-(alpha*singularValueComp(i,j,k)))/(1-alpha);
%             if temp<97
%                 imageAnalogus(i,j,k)=0;
%             else
%                 imageAnalogus(i,j,k)=1;
%             end
%             %             dctWatermark(i,j,k);
%         end
%     end
% end

%% Post-processing
% imageAnalogus=invdct(imageAnalogus);
% recdctValue=dctWatermark;
sz11=size(singularValueComp);
dimensionsOfWatermark=[ceil(sqrt(sz11(1)*sz11(2)*sz11(3))) ceil(sqrt(sz11(1)*sz11(2)*sz11(3)))];
watermfinal=retiling4x4intoImage(imageAnalogus,dimensionsOfWatermark,dimensionsOfWatermark);

%% Output
recoveredWImage=uint8( watermfinal);
end
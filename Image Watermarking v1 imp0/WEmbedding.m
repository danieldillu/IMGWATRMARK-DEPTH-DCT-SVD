function [wdimage]=WEmbedding(hostImage,gtImage,watrmarkImg,alphaValuebgfg)
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
[blockedMat4x4,hnewdimen]=blocking4x4fromnxn(icA);
[u_comp,s_comp,v_comp,singularValueComp]=svdTransform(blockedMat4x4);
dctValuesofHost=dctBox(singularValueComp);

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
imrestwr=imresize(watrmarkImg,dimensionsOfWatermark);
  imrestwr1=im2bw(imrestwr,graythresh(imrestwr));
% if isWatermarkBinary
%     imrestwr1=im2bw(imrestwr,graythresh(imrestwr));
% else
%     imrestwr1=imrestwr;
% end
[blocked4x4wtr,~]=blocking4x4fromnxn(imrestwr1);
mblockedwtr=double(blocked4x4wtr);
for i=1:size(blocked4x4wtr,1)
    for j=1:size(blocked4x4wtr,2)
        for k=1:size(blocked4x4wtr,3)
            if blocked4x4wtr(i,j,k)==1
                mblockedwtr(i,j,k)=251;
            else
                mblockedwtr(i,j,k)=5;
            end
        end
    end
end
% dctvaluewtr=dctBox(blocked4x4wtr);
% dctvaluewtr=mblockedwtr;

%% Watermark Intermediate Value Modification

sz3=size(dctValuesofHost);
dctValueMod=double(zeros(sz3));
for i=1:sz3(1)
    for j=1:sz3(2)
        for k=1:sz3(3)
            
            alpha=alphagtblocked(i,j,k); antialfa=1-alpha;
            dctValueMod(i,j,k)=(dctValuesofHost(i,j,k)*alpha)+(antialfa*mblockedwtr(i,j,k));
            
        end
        
    end
end

% sz3=size(singularValueComp);
% modsingValue=double(zeros(sz3));
% for i=1:sz3(1)
%     for j=1:sz3(2)
%         for k=1:sz3(3)
%             
%             alpha=alphagtblocked(i,j,k); antialfa=1-alpha;
%             modsingValue(i,j,k)=(singularValueComp(i,j,k)*alpha)+(antialfa*mblockedwtr(i,j,k));
%             
%         end
%         
%     end
% end

%% Post-processing

invDCTValue=invdct(dctValueMod);
[~,img4r]=invsvd(invDCTValue,u_comp,s_comp,v_comp);
% [~,img4r]=invsvd(modsingValue,u_comp,s_comp,v_comp);

recimgA=retiling4x4intoImage(img4r,hnewdimen,size(icA));
imagerec=idwt2(recimgA,icH,icV,icD,'Haar');

WatermarkPostProcessed=rounding10p10(imagerec);

%% Output
wdimage=WatermarkPostProcessed;
end
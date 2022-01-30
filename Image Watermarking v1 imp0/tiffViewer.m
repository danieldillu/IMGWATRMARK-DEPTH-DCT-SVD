function []=tiffViewer(Filepath)
% fpaths='';
[fpath,fname,fext]=fileparts(Filepath);
if strcmp(fext,'.tif')
    fpaths=Filepath;
elseif strcmp(fext,'.png')
    fpaths=Filepath;
elseif strcmp(fext,'.jpg')
    fpaths=Filepath;
elseif strcmp(fext,'.jpeg')
    fpaths=Filepath;
elseif strcmp(fext,'.bmp')
    fpaths=Filepath;
else
    error('tiffViewer: Please check the whether %s is a Image.',strcat(fname,fext));
end

temp=imread(fpaths);
figure,imshow(temp,[]);

end
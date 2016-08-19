function [I,L] = PEEMintensity(name,number )
% This function analyze the intensity of PEEM images 
close all
% Input the images
filename = 'circular_minus.TIF';
%filename = sprintf('%s%04d.jpg',name,number);
I = imread(filename);
 imshow(I);
 hold on;
% Image segmentation
% Plot the gradiant magnitude
% hy = fspecial('sobel');
% hx = hy';
% Iy = imfilter(double(I),hy,'replicate');
% Ix = imfilter(double(I),hx,'replicate');
% gradmag = sqrt(Ix.^2+Iy.^2);
% figure
% imshow(gradmag,[]), title('gradient magnitude')

% Watershed segmentation
% L = watershed(gradmag);
% Lrgb = label2rgb(L);
% figure,imshow(Lrgb),title('Watershed transform of gradient magnitude')

se = strel('disk',3);
sesmall = strel('disk',1);
% image opening
% 
% Io = imopen(I, se);
%  figure
%  imshow(Io),title('Opening')

% image by reconstrction

Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
% figure
% imshow(Iobr),title('Opening-by-reconstruction')


% Plot the gradiant magnitude
% hy = fspecial('sobel');
% hx = hy';
% Iy = imfilter(double(Iobr),hy,'replicate');
% Ix = imfilter(double(Iobr),hx,'replicate');
% gradmag = sqrt(Ix.^2+Iy.^2);
% figure
% imshow(gradmag,[]), title('gradient magnitude after reconstruction')



% closing
% Ioc = imclose(Io, sesmall);
% figure
% imshow(Ioc),title('opening-closing')

% reconstructed-based opening and closing
Iobrd = imdilate(Iobr, sesmall);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
 figure
 imshow(Iobrcbr),title('opening-closing by reconstruction')

%obtain foreground markers
fgm = imregionalmax(Iobrcbr);
figure
imshow(fgm),title('regional maxima of opening-closing by reconstruction')

% 
se2 = strel(ones(2,2));
fgm2 = imclose(fgm,se2);
fgm3 = imclose(fgm2,se2);
fgm4 = bwareaopen(fgm3, 20);
I3 = I;
I3(fgm4) = 255;
figure
imshow(I3),title('modified regional maxima')
% hold on;
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(fgm4),hy,'replicate');
Ix = imfilter(double(fgm4),hx,'replicate');
gradmag = sqrt(Ix.^2+Iy.^2);
figure
imshow(gradmag,[]), title('gradient magnitude after reconstruction')
%compute background markers
% bw = imbinarize(Iobrcbr,'adaptive','sensitivity',0.03);
% figure
% imshow(bw), title('Thresholded opening-closing by reconstruction')
% D = bwdist(bw);
% DL = watershed(D);
% bgm = DL == 0;
% figure
% imshow(bgm),title('watershed ridge lines')

%
% gradmag2 = imimposemin(gradmag,  fgm4);
% Watershed segmentation
L = watershed(gradmag);
Lrgb = label2rgb(L);
figure,imshow(Lrgb),title('Final watershed transform of gradient magnitude');
hold on;
end


function outimage = myCLAHE(I)

%ADAPTHISTEQ Contrast-limited Adaptive Histogram Equalization (CLAHE).
%   ADAPTHISTEQ enhances the contrast of images by transforming the
%   values in the intensity image I.  Unlike HISTEQ, it operates on small
%   data regions (tiles), rather than the entire image. Each tile's 
%   contrast is enhanced, so that the histogram of the output region
%   approximately matches the specified histogram. The neighboring tiles 
%   are then combined using bilinear interpolation in order to eliminate
%   artificially induced boundaries.  The contrast, especially
%   in homogeneous areas, can be limited in order to avoid amplifying the
%   noise which might be present in the image.

%--------------------------- The algorithm ----------------------------------
%
%  1. Obtain all the inputs: 
%    * image
%    * number of regions in row and column directions
%    * number of bins for the histograms used in building image transform
%      function (dynamic range)
%    * clip limit for contrast limiting (normalized from 0 to 1)
%    * other miscellaneous options
%  2. Pre-process the inputs:  
%    * determine real clip limit from the normalized value
%    * if necessary, pad the image before splitting it into regions
%  3. Process each contextual region (tile) thus producing gray level mappings
%    * extract a single image region
%    * make a histogram for this region using the specified number of bins
%    * clip the histogram using clip limit
%    * create a mapping (transformation function) for this region
%  4. Interpolate gray level mappings in order to assemble final CLAHE image
%    * extract cluster of four neighboring mapping functions
%    * process image region partly overlapping each of the mapping tiles
%    * extract a single pixel, apply four mappings to that pixel, and 
%      interpolate between the results to obtain the output pixel; repeat
%      over the entire image
%
%  See code for further details.
%
%-----------------------------------------------------------------------------
image=imread(I);
% if numel(size(I))>2
%        image=rgb2gray(image);         
% end 
% B=image(:,:,1);
% G=image(:,:,2);
% R=image(:,:,3);
outimage=image;
for i = 1:3
    I=image(:,:,i);
    I=imresize(I,[floor(size(I,1)/8)*8,floor(size(I,2)/8)*8]);
    dimI = size(I);% 图像大小

    % 'NumTiles'  Two-element vector of positive integers: [M N].
    %                    [M N] specifies the number of tile rows and
    %                    columns.  Both M and N must be at least 2. 
    %                    The total number of image tiles is equal to M*N.
    %                    Default: [8 8].
    numTiles = [8 8];% 8*8个图像块
    %size of the single tile
    dimTile = dimI ./ numTiles;% 每个图像块的维数
    %Controls the range of the output image data. e.g. [0 255] for uint8
    fullRange = [0 255];%灰度值范围

    %   'NBins'        Positive integer scalar.
    %                  Sets number of bins for the histogram used in building a
    %                  contrast enhancing transformation. Higher values result 
    %                  in greater dynamic range at the cost of slower processing
    %                  speed.
    %
    %                  Default: 256.
    numBins = 256;%灰度级数
    %   'normClipLimit'    Real scalar from 0 to 1. Default: 0.01.
    %   'ClipLimit'             limits contrast enhancement. Higher numbers 
    %                                result in more contrast. 
    %compute actual clip limit from the normalized value entered by the user
    %maximum value of normClipLimit=1 results in standard AHE, i.e. no clipping;
    %the minimum value minClipLimit would uniformly distribute the image pixels
    %across the entire histogram, which would result in the lowest possible
    %contrast value
    normClipLimit = 0.01;
    numPixInTile = prod(dimTile);%prob计算矩阵每列元素的乘积。图像分成8*8，每一个块所包含的像素点个数
    minClipLimit = ceil(numPixInTile/numBins);%达到真正直方图均衡时（直方图是直线）的纵坐标（像素个数）.每个灰度级的像素点个数
    clipLimit = minClipLimit + round(normClipLimit*(numPixInTile-minClipLimit));%设置的限制对比度的裁剪限幅
    tileMappings = makeTileMappings(I, numTiles, dimTile, numBins, clipLimit, ...
                                     fullRange);

    %Synthesize the output image based on the individual tile mappings. 
    out = makeClaheImage(I, tileMappings, numTiles, ...
                         dimTile);
    outimage(:,:,i)=out;
end

% imshow(outimage);
end


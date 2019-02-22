%WOLF local thresholding.
%   BW = WOLF(IMAGE) performs local thresholding of a two-dimensional 
%   array IMAGE with Wolf's algorithm.
%      
%   BW = WOLF(IMAGE, [M N], THRESHOLD, PADDING) performs local 
%   thresholding with M-by-N neighbourhood (default is 3-by-3) and 
%   threshold THRESHOLD between 0 and 1 (default is 0.5). 
%   To deal with border pixels the image is padded with one of 
%   PADARRAY options (default is 'replicate').
%       
%   Example
%   -------
%       imshow(wolf(imread('eight.tif'), [250 250]));
%
%   See also PADARRAY, RGB2GRAY.
%   For method description see:
%       http://dx.doi.org/10.1117/12.805827
%   Contributed by Jan Motl (jan@motl.us)
%   $Revision: 1.0 $  $Date: 2013/05/09 16:58:01 $
function output=wolf(image, varargin)
% Initialization
numvarargs = length(varargin);      % only want 3 optional inputs at most
if numvarargs > 3
    error('myfuns:somefun2Alt:TooManyInputs', ...
     'Possible parameters are: (image, [m n], threshold, padding)');
end
 
optargs = {[3 3] 0.5 'replicate'};  % set defaults
 
optargs(1:numvarargs) = varargin;   % use memorable variable names
[window, k, padding] = optargs{:};
if ndims(image) ~= 2
    error('The input image must be a two-dimensional array.');
end
% Convert to double
image = double(image);
% Mean value
mean = averagefilter(image, window, padding);
% Standard deviation
meanSquare = averagefilter(image.^2, window, padding);
deviation = (meanSquare - mean.^2).^0.5;
% Wolf
R = max(deviation(:)); 
M = min(image(:));
threshold = bsxfun(@plus, (1-k)*mean+k*deviation./R.*(mean-M), k*M);
output = (image > threshold);
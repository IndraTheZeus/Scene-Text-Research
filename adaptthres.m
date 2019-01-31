%NIBLACK local thresholding.
%   BW = NIBLACK(IMAGE) performs local thresholding of a two-dimensional
%   array IMAGE with Niblack method. 
%      
%   BW = NIBLACK(IMAGE, [M N], K, OFFSET, PADDING) performs local
%   thresholding with M-by-N neighbourhood (default is 3-by-3). The default
%   value for K is -0.2. The default value of OFFSET is 0, which 
%   coresponds to the original Niblack implementation. To deal with border 
%   pixels the image is padded with one of PADARRAY options (default is 
%   'replicate').
%       
%   Example
%   -------
%       imshow(niblack(imread('eight.tif'), [25 25], -0.2, 10));
%
%   See also PADARRAY, RGB2GRAY.

%   Contributed by Jan Motl (jan@motl.us)
%   $Revision: 1.0 $  $Date: 2013/03/09 16:58:01 $

function [output,l1] = adaptthres(image,mk,mk1, varargin)
% Initialization
numvarargs = length(varargin);      % only want 4 optional inputs at most
if numvarargs > 4
    error('myfuns:somefun2Alt:TooManyInputs', ...
     'Possible parameters are: (image, [m n], k, offset, padding)');
end
 
optargs = {[3 3] -0.2 0 'replicate'};   % set defaults
 
optargs(1:numvarargs) = varargin;   % use memorable variable names
[window, k, offset, padding] = optargs{:};

if ndims(image) ~= 2
    error('The input image must be a two-dimensional array.');
end

% Convert to double
image = double(image);
lk=graythresh(image);
% Mean value
mean = averagefilter(image, window, padding);

% Standard deviation
meanSquare = averagefilter(image.^2, window, padding);
deviation = (meanSquare - mean.^2).^0.5;
var=(meanSquare - mean.^2);
% Initialize the output
output = zeros(size(image));

% Niblack5
% l1=mean + (-0.5).*deviation-offset;%threshold
%Sauvola
  l1=mean.*( 1+((0.5) .* (double((deviation/128))-1)));

output(image > l1) = 1;
%my
%k=0.9*(((mean)/mk)+((deviation)/mk1));
%l1=(mean-(mean/mk))+ (k).*(deviation-(deviation/mk1))-offset;
%k=(-0.25)*(deviation+mean)/(mk1+mk);
%output(image > ((mean-(mean/mk))+ (k).*(deviation-(deviation/mk1)))-offset) = 1;
function [binImg,T] = SauvolaBinary(img, k, nbsize)
% Binarization method using Sauvola thresholding method
%input: size is the half width of the window
nbsize = floor(nbsize);
[M,N,K] = size(img);
if(K > 1)
    img = rgb2gray(img);
end
img = double(img);
%[M,N] = size(img);
T = zeros(M,N);
% compute the mean
nbsize = 2*nbsize + 1;
n = nbsize*nbsize;%the number of neighbor pixels
H = ones(nbsize,nbsize);
sp = imfilter(double(img),double(H),'corr','replicate','same');
m = sp ./ n;
% compute the std
if k ~= 0 
    sp2 = imfilter(double(img.^2),double(H),'corr','replicate','same');
    v = (sp2 + n*m.^2 - 2*m.*sp)./(n-1);
    v = sqrt(v);
    T = m.*(1+ k.*(v./128 - 1));
else
    T = m;
end

binImg = img > T;
end


%%

%k = 0.2,0.3,0.4,0.5;

%nbsize = 10,12,14,16,18,20


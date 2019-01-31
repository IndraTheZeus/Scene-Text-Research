%%%%%%%%%    Swell Filter

% imgBin = input binary image
% windowSize = an odd number
% threshold = [0,1]
function[swelledImage]=swell_shrink(imgBin,windowSize,threshold)
img=imgBin;
[row,col]=size(img);
loop=floor(windowSize/2);
nearestNeighbors=windowSize*windowSize-1;
nearestBackgroundProb=ceil(nearestNeighbors*threshold);

for r1=1:row
    for c1=1:col
        if(img(r1,c1)==1)            
            nearestPixelsSum=0;
            for k=1:loop
                r2=r1-k;
                c2=c1-k;
                if((r2<1)||(c2<1)||(r2>row)||(c2>col))
                    nearestPixelsSum=nearestPixelsSum+1;
                else
                    nearestPixelsSum=nearestPixelsSum+img(r2,c2);
                end    
                for l=1:k*2
                    c2=c2+1;
                    if((r2<1)||(c2<1)||(r2>row)||(c2>col))
                        nearestPixelsSum=nearestPixelsSum+1;
                    else
                        nearestPixelsSum=nearestPixelsSum+img(r2,c2);
                    end
                end
                for l=1:k*2
                    r2=r2+1;
                    if((r2<1)||(c2<1)||(r2>row)||(c2>col))
                        nearestPixelsSum=nearestPixelsSum+1;
                    else
                        nearestPixelsSum=nearestPixelsSum+img(r2,c2);
                    end
                end
                for l=1:k*2
                    c2=c2-1;
                    if((r2<1)||(c2<1)||(r2>row)||(c2>col))
                        nearestPixelsSum=nearestPixelsSum+1;
                    else
                        nearestPixelsSum=nearestPixelsSum+img(r2,c2);
                    end
                end
                for l=1:k*2-1
                    r2=r2-1;
                    if((r2<1)||(c2<1)||(r2>row)||(c2>col))
                        nearestPixelsSum=nearestPixelsSum+1;
                    else
                        nearestPixelsSum=nearestPixelsSum+img(r2,c2);
                    end
                end   
            end
            nearestPixelsSum=nearestNeighbors-nearestPixelsSum;
            if(nearestPixelsSum>=nearestBackgroundProb)
                img(r1,c1)=0;
            end  
        end
    end
end                   
swelledImage=img;           
           


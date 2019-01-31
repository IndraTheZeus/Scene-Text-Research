 
function result=RLSA(image)
hor_thresh=5;
zeros_count=0;
one_flag=0;
hor_image=image;
[m,n]=size(image);
for i=1:m
    zeros_count=0;
    for j=1:n
        if(image(i,j)==1)
            if(one_flag==1)
                if(zeros_count<=hor_thresh)
                    hor_image(i,j-zeros_count:j-1)=1;
                else
                    one_flag=0;
                end
                zeros_count=0;
            end
            one_flag=1;
        else 
            if(one_flag==1)
                zeros_count=zeros_count+1;
            end
        end
    end
    
     
end

result=hor_image;
end


 
% zeros_count=0;
% one_flag=0;
% 
% for i=1:n
%     for j=1:m
%         if(image(j,i)==1)
%             if(one_flag==1)
%                 if(zeros_count<=hor_thresh)
%                     hor_image(j-zeros_count:j-1,i)=1;
%                 else
%                     one_flag=0;
%                 end
%                 zeros_count=0;
%             end
%             one_flag=1;
%         else 
%             if(one_flag==1)
%                 zeros_count=zeros_count+1;
%             end
%         end
%     end
% end
%  result=hor_image;
% end

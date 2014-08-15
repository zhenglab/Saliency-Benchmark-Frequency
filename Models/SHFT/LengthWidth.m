function [LW Mid]=LengWidth(img)

%% Hou的signature处理
rgbMap = signature( img );
smap=mat2gray(rgbMap);
%% 自适应阈值
level=graythresh(smap);
bw=im2bw(smap,level);

[L n] = bwlabel(bw);
stats = regionprops(L,'Area'); % 区域属性

num=max(max(L));
LW=zeros(num,2);Mid=zeros(num,2);
for i=1:num;
    [r c]=find(L==i);
    if length(r)>10
        [rectx,recty,area,perimeter] = minboundrect(c,r,'a'); % 'a'是按面积算的最小矩形，如果按边长用'p'.
        %line(rectx,recty,'color','r');
        if (rectx(1)~=rectx(2))&&(recty(1)~=recty(3))
            l1=sqrt(((rectx(2)-rectx(1))^2)+(recty(2)-recty(1))^2); % l1、l2求出图像的长度和宽度.
            l2=sqrt(((rectx(4)-rectx(1))^2)+(recty(4)-recty(1))^2);
            mx=0.5.*(rectx(1)+rectx(3));
            my=0.5.*(recty(1)+recty(3));
            LW(i,1)=l1;
            LW(i,2)=l2;
            Mid(i,1)=mx;
            Mid(i,2)=my;
        end
    end
end




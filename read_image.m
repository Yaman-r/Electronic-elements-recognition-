function [feature] = read_image(im)

info=img_process(im);
%% Calculate the Aspect Ratio.
imBox = [info.BoundingBox];
feature(1,1)=imBox(4)/imBox(3);
%% Extrema..
e=info.Extrema;
feature(1,2:5)=[sqrt((e(3,2)-e(2,2)).^2+(e(3,1)-e(2,1)).^2),...
    sqrt((e(5,2)-e(4,2)).^2+(e(5,1)-e(4,1)).^2),...
    sqrt((e(7,2)-e(6,2)).^2+(e(7,1)-e(6,1)).^2),...
    sqrt((e(1,2)-e(8,2)).^2+(e(1,1)-e(8,1)).^2)];
%% Color
%The sum of pixels -(RED) channel 
z1=sum(sum(im(:,:,1),1),2);
%The sum of pixels -(Green) channel 
z2=sum(sum(im(:,:,2),1),2);
%The sum of pixels -(Blue) channel 
z3=sum(sum(im(:,:,3),1),2);
z=[z1,z2,z3];
s = size(im);
feature(1,6:8)=round(z/(s(1)*s(2)));
%% Number of Holes
feature(1,9)=info.EulerNumber;
end

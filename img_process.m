function info=img_process(im) 
%-----------------------
%Image Process Algorithm
%-----------------------
%% -----------------------
%Step 1 :
%Convert RGB Image to Binary Image ,based on threshold
%-----------------------
%Graythresh:global image threshold using Otsu’s method 
background=imopen(im,strel('disk',15));
level=graythresh(background);
bw=im2bw(background,level);
%% ------------
%Step 2 :
%Remove small objects from binary image
%------------
B=bwareaopen(bw,30);
%% ------------
%Step 3 :
%Morphologically close image
%------------
se=strel('square',30); 
B=imclose(bw,se);
%figure;imshow(B)
%% ------------
%Step 4 :
%Label connected components in Binary Image
%------------
[lebeled,numObjects]=bwlabeln(~B,4);
%% ------------
%Step 5 :
%Measure properties of image regions.
info=regionprops(lebeled,'BoundingBox','EulerNumber','Extrema');
%* BoundingBox:The smallest rectangle containing the region
%* EulerNumber:Scalar that specifies the number of objects in the region...
%    ...minus the number of holes in those objects.
%* Extrema: 8-by-2 matrix that specifies the extrema points in the region..
%          ..each row of the matrix contains the x- and y-coordinates of
%          one of the points.
%          The format of the vector is :
%         [top-left,top-right,right-top,right-bottom,bottom-right,bottom-left,left-bottom,left-top]
end
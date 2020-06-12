% This script shows how the finger region and edges can be detected.
function [region] = lee_usage(img2)
img = im2double(img2); % Read image
%img = imresize(img, 0.9);   
 % Downscale image

mask_height=4; % Height of the mask
mask_width=20; % Width of the mask
[fvr, edges] = lee_region(img,mask_height,mask_width);

% köşeleri gösteren fotonun oluşturulması
edge_img = zeros(size(img));
edge_img(edges(1,:) + size(img,1)*[0:size(img,2)-1]) = 1;
edge_img(edges(2,:) + size(img,1)*[0:size(img,2)-1]) = 1;

rgb = zeros([size(img) 3]);
rgb(:,:,1) = (img - img.*edge_img) + edge_img;
rgb(:,:,2) = (img - img.*edge_img);
rgb(:,:,3) = (img - img.*edge_img);

% Show the original, detected region and edges in one figure

region=fvr;
end

function IPre = Preprocess(I)
% This function Preprocess the original image before performing
% frequency domain filtering.
% 
% INPUT: 
%         I = Original RGB Image which has to be filtered
% OUTPUT:
%         IPre = Its a structure with following fields
%                        D = 
%                       If = 
%              revertclass = 

% ASHISH MESHRAM (meetashish85@gmail.com

% Implementation starts here

[m n o] = size(I);
if o~=1
    Ig = im2double(rgb2gray(I));
else
    Ig = im2double(I);
end
PQ = paddedsize(size(Ig));
[U, V] = dftuv(PQ(1),PQ(2));
IPre.o = o;
IPre.Ig = Ig;
IPre.PQ = PQ;
IPre.D = sqrt(U.^2 + V.^2);
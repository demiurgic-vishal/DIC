function vec = findtranslation(A,B)
%FINDTRANSLATION Find translation vector.
%   VEC = FINDTRANSLATION(A,B) finds the translation vector between
%   images A and B. VEC = [tx ty] where tx and ty specify the number of pixels
%   needed to shift image A to bring it into alignment with image B.

% Copyright 2011 The MathWorks, Inc.

narginchk(2,2)

% Align the geometric centers of the two images.
[rowsA,colsA,~] = size(A);
[rowsB,colsB,~] = size(B);

vec = [(rowsB - rowsA), (colsB - colsA)] ./ 2;

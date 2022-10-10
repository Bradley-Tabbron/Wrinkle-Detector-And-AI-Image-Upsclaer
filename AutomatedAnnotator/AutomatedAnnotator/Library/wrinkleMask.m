%% Extracting different wrinkle sizes
%
%  Author: Moi Hoon Yap
%  Date: 19/10/16
%  Purpose: extracting different wrinkles sizes based on:
%           type: 1 for horizontal line, 2 for vertical line
%           R1 & R2: FrangiScaleRange:(1 - 8)
%           thresh = thresholding (0.4 for coarse, 0.2 for fine)
%
%% Begin of function

function output = wrinkleMask(input, R1, R2, thresh, type)
  
  [r c ch] = size(input);
  if (ch>1)
    input = rgb2gray(input);
  end
  [Gx, Gy] = imgradientxy(input);
  if type==1
      imDirection = Gy;
  else
      imDirection = Gx;
  end
  
  options.FrangiScaleRange = [R1 R2];
  options.FrangiScaleRatio = 2;
  options.FrangiBetaOne = 0.5;
  options.FrangiBetaTwo = 15;
  options.BlackWhite = false;
  [imgHHF, atScale, atDirection, allFilters]=FrangiFilter2D(imDirection, options);
  output = allFilters;
  
end
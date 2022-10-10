%% Produce lines
%
%  Author: Moi Hoon Yap
%  Date: 21/10/16
%  Purpose: Combine two input binary images when there are overlap between
%  lines
%           
%% Begin of function

function mask = produceLines(input, type, thresh, scale1, scale2)

  out1 = filterDiff(input,scale1,scale1,thresh, type);
  out2 = filterDiff(input,scale2, scale2, thresh, type);
  mask = zeros(size(out1));
  % Split line into fine lines and coarse lines
  [mask1 dummy1] = SplitLines(out1, out2);
  [dummy2 mask2] = SplitLines(out2, out1);

  mask = dummy1 + mask2;

end 
%% Splitting fine and coarse lines
%
%  Author: Moi Hoon Yap
%  Date: 20/10/16
%  Purpose: Splitting two input binary images to two binary masks
%           - one with coarse lines, the other with fine lines
%           input1: input mask with lower sigma
%           input2: input mask with higher sigma
%           mask1: output for fine lines
%           mask2: output for coarse lines
%% Begin of function

function [mask1 mask2] = SplitLines(input1, input2)
    % Label the regions
    [L num] = bwlabel(input1,4);
    s = regionprops(L,'Area');
    % filter small region/noise
    area_values = [s.Area];
    idx = find(10 <= area_values);
    bw1 = ismember(L, idx);
    
    % initialise mask1 & mask2
    mask1 = zeros(size(input1));
    mask2 = zeros(size(input1));
    
    % checking overlap
    [L num] = bwlabel(bw1,4);
    for i=1:num
        dummy = ismember(L,i);
        if sum(sum(dummy&input2))>10
            mask2 = mask2|dummy;
        else 
            mask1 = mask1|dummy;
        end
    end
    
    
  
end
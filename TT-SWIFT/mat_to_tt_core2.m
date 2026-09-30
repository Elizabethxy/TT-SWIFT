function G2 = mat_to_tt_core2(G2_mat, r1, I2, r2)
% Convert matrix form back to the second TT-core.
%
% Input:
%   G2_mat : I2 × (r1*r2)
%   r1     : left TT rank
%   I2     : mode-2 dimension
%   r2     : right TT rank
%
% Output:
%   G2     : r1 × I2 × r2

    temp = reshape(G2_mat, I2, r1, r2);

    % temp: I2 × r1 × r2
    % convert back to r1 × I2 × r2
    G2 = permute(temp, [2, 1, 3]);

end
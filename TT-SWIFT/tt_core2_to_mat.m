function G2_mat = tt_core2_to_mat(G2)
% Convert the second TT-core into matrix form.
%
% Input:
%   G2      : r1 × I2 × r2
%
% Output:
%   G2_mat  : I2 × (r1*r2)
%
% For mode-2 unfolding:
%   X_(2) = G2_mat * H2'

    [r1, I2, r2] = size(G2);

    % G2: r1 × I2 × r2
    % permute to I2 × r1 × r2
    % then reshape to I2 × (r1*r2)
    G2_mat = reshape(permute(G2, [2, 1, 3]), I2, r1*r2);

end
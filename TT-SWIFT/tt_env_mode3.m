function H3 = tt_env_mode3(G1, G2)
% Construct TT environment matrix for mode-3 unfolding.
%
% TT format:
%   G1 : I1 × r1
%   G2 : r1 × I2 × r2
%
% Output:
%   H3 : (I1*I2) × r2
%
% Mode-3 unfolding:
%   X_(3) = G3_mat * H3'
% where:
%   G3_mat = G3'

    [I1, r1] = size(G1);
    [r1_check, I2, r2] = size(G2);

    assert(r1 == r1_check, 'Dimension mismatch: size(G1,2) must equal size(G2,1).');

    H3 = zeros(I1*I2, r2);

    for a2 = 1:r2
        % G2(:,:,a2): r1 × I2
        M = squeeze(G2(:, :, a2));       % r1 × I2

        % Contract G1 and G2 over r1
        HG = G1 * M;                     % I1 × I2

        % Vectorize over (i1,i2)
        H3(:, a2) = reshape(HG, [], 1);
    end

end
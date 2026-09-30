function H1 = tt_env_mode1(G2, G3)
% Construct TT environment matrix for mode-1 unfolding.
%
% TT format:
%   G1 : I1 × r1
%   G2 : r1 × I2 × r2
%   G3 : r2 × I3
%
% Output:
%   H1 : (I2*I3) × r1
%
% Mode-1 unfolding:
%   X_(1) = G1 * H1'

    [r1, I2, r2] = size(G2);
    [r2_check, I3] = size(G3);

    assert(r2 == r2_check, 'Dimension mismatch: size(G2,3) must equal size(G3,1).');

    H1 = zeros(I2*I3, r1);

    for a1 = 1:r1
        % G2(a1,:,:) has size I2 × r2 after squeeze
        M = squeeze(G2(a1, :, :));     % I2 × r2

        % Contract G2 and G3 over r2
        HG = M * G3;                   % I2 × I3

        % Vectorize over (i2,i3)
        H1(:, a1) = reshape(HG, [], 1);
    end

end
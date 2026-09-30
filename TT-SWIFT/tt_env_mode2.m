function H2 = tt_env_mode2(G1, G3)
% Construct TT environment matrix for mode-2 unfolding.
%
% TT format:
%   G1 : I1 × r1
%   G3 : r2 × I3
%
% Output:
%   H2 : (I1*I3) × (r1*r2)
%
% Mode-2 unfolding:
%   X_(2) = G2_mat * H2'

    [I1, r1] = size(G1);
    [r2, I3] = size(G3);

    H2 = zeros(I1*I3, r1*r2);

    col = 1;

    for a1 = 1:r1
        for a2 = 1:r2

            % Outer product over document and word-3 modes
            M = G1(:, a1) * G3(a2, :);   % I1 × I3

            % Vectorize over (i1,i3)
            H2(:, col) = reshape(M, [], 1);

            col = col + 1;
        end
    end

end
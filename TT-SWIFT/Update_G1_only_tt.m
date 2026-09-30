function G1 = Update_G1_only_tt(G1, G2, G3, OT, Unique_nz_col)
% UPDATE_G1_ONLY_TT
% Fixed G2 and G3, update only G1 using the same KL/MU rule as TT-SWIFT.
%
% Inputs:
%   G1 : I1 x r1
%   G2 : r1 x I2 x r2
%   G3 : r2 x I3
%   OT : cell array, OT{1}, OT{2}, OT{3}
%   Unique_nz_col : nonzero column indices for each unfolding
%
% Output:
%   G1 : updated I1 x r1

    I1 = size(G1, 1);
    r1 = size(G1, 2);

    [r1_check, I2, r2] = size(G2);
    assert(r1 == r1_check, ...
        'Dimension mismatch: size(G1,2) must equal size(G2,1).');

    [r2_check, I3] = size(G3);
    assert(r2 == r2_check, ...
        'Dimension mismatch: size(G2,3) must equal size(G3,1).');
    

    % =========================
    % Recover Delta matrices
    % =========================

    Delta_1_FULL = zeros(I2 * I3, I1);
    Delta_1_FULL(Unique_nz_col{1}, :) = OT{1};

    Delta_2_FULL = zeros(I1 * I3, I2);
    Delta_2_FULL(Unique_nz_col{2}, :) = OT{2};

    Delta_3_FULL = zeros(I1 * I2, I3);
    Delta_3_FULL(Unique_nz_col{3}, :) = OT{3};

    H1 = tt_env_mode1(G2, G3);

    D2 = permute(reshape(Delta_2_FULL, [I1, I3, I2]), [3, 2, 1]);
    D2_tilde = reshape(D2, [I2 * I3, I1]);

    D3 = permute(reshape(Delta_3_FULL, [I1, I2, I3]), [2, 3, 1]);
    D3_tilde = reshape(D3, [I2 * I3, I1]);
    
    G1 = KL_update_rule_tt( ...
        [Delta_1_FULL; D2_tilde; D3_tilde], ...
        [H1; H1; H1], ...
        G1' ...
    )';

    G1 = max(G1, 1e-12);

end
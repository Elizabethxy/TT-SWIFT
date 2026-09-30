function [G1,G2,G3] = Update_factor_tt(G1,G2,G3,OT,Unique_nz_col)

I1 = size(G1,1);
r1 = size(G1,2);

[r1_check,I2,r2] = size(G2);
assert(r1 == r1_check);

[r2_check,I3] = size(G3);
assert(r2 == r2_check);

Delta_1_FULL=zeros(I2*I3,I1);
Delta_1_FULL(Unique_nz_col{1},: )=OT{1};

Delta_2_FULL=zeros(I1*I3,I2);
Delta_2_FULL(Unique_nz_col{2},: )=OT{2};

Delta_3_FULL=zeros(I1*I2,I3);
Delta_3_FULL(Unique_nz_col{3},: )=OT{3};





% ===================== update First Factor matrix ========================


H1 = tt_env_mode1(G2,G3);




D2 = permute(reshape(Delta_2_FULL, [I1,I3,I2]), [3, 2, 1]); %has same size as D1
D2_tilde = reshape(D2, [I2*I3,I1]);

D3=permute(reshape(Delta_3_FULL, [I1, I2, I3]), [2, 3, 1]); %has same size as D1
D3_tilde = reshape(D3, [I2*I3,I1]);




G1=KL_update_rule_tt( [Delta_1_FULL;D2_tilde;D3_tilde] , [H1;H1;H1] , G1' )';

G1 = max(G1, 1e-12);

%Factors{1}=normc(Factors{1});




% ===================== update Second Factor matrix ========================

H2 = tt_env_mode2(G1,G3);

G2_mat = tt_core2_to_mat(G2);


D1= permute(reshape(Delta_1_FULL, [I2, I3, I1]), [3, 2, 1]); %has same size as D2
D1_tilde = reshape(D1, [I1*I3,I2]);

D3= permute(reshape(Delta_3_FULL, [I1, I2, I3]), [1, 3, 2]); %has same size as D2
D3_tilde = reshape(D3, [I1*I3,I2]);


G2_mat=KL_update_rule_tt( [D1_tilde;Delta_2_FULL;D3_tilde] , [H2; H2; H2] ,G2_mat' )';
G2_mat = max(G2_mat, 1e-12);

G2 = mat_to_tt_core2(G2_mat,r1,I2,r2);

%Factors{2}=normc(Factors{2});


% ===================== Update Third Factor matrix ========================

H3 = tt_env_mode3(G1,G2);

G3_mat = G3';

D1= permute(reshape(Delta_1_FULL, [I2, I3, I1]), [3, 1, 2]); %has same size as D3
D1_tilde = reshape(D1, [I1*I2,I3]);

D2 = permute(reshape(Delta_2_FULL, [I1, I3, I2]), [1, 3, 2]); %has same size as D3
D2_tilde = reshape(D2, [I1*I2,I3]);


%KL_left=(D1_tilde+D2_tilde+Delta_3_FULL)./3;

G3_mat=KL_update_rule_tt( [D1_tilde;D2_tilde;Delta_3_FULL] , [H3;H3;H3] ,G3_mat' )';

G3_mat = max(G3_mat, 1e-12);

G3 = G3_mat';
end


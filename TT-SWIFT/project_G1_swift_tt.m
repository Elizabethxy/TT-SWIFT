function [G1_test] = project_G1_swift_tt(X, G2_train, G3_train, ranks, C1, C2, C3, options, seed, PARFOR)
% PROJECT_G1_SWIFT_TT
% Fixed trained G2 and G3, update only G1_test using SWIFT-type projection.

    size_doc   = size(X, 1);
    size_word1 = size(X, 2);
    size_word2 = size(X, 3);

    r1 = ranks(1);
    r2 = ranks(2);


    K = {};
    [rho,~,~] = tt_transport_parameters(options);
    K{1} = exp(-rho * C1 - 1);
    K{2} = exp(-rho * C2 - 1);
    K{3} = exp(-rho * C3 - 1);

    rng(seed);

    G1 = rand(size_doc, r1);
    G1 = max(G1, 1e-12);

    G2_fixed = G2_train;
    G3_fixed = G3_train;

    N = length(size(X));

    X_mat = {};
    Unique_nz_col = {};

    for n = 1:N

        X_mat{n} = double(sptenmat(X, n));
        Unique_nz_col{n} = unique_col_ind_tt(X_mat{n}, 0);

        if ~isempty(Unique_nz_col{n})
            fprintf('max(Unique_nz_col{%d}) = %d\n', n, max(Unique_nz_col{n}));
        end

        fprintf('number of columns in X_mat{%d} = %d\n', n, size(X_mat{n},2));

    end

    ITER = options.Total_iteration;

    for itr = 1:ITER

        if ~isfield(options,'verbose') || options.verbose
            fprintf('\nProjection iteration = %d\n', itr);
        end

        Factors = {};
        Factors{1} = G1;
        Factors{2} = tt_core2_to_mat(G2_fixed);
        Factors{3} = G3_fixed';

        ENV = {};
        ENV{1} = tt_env_mode1(G2_fixed, G3_fixed);
        ENV{2} = tt_env_mode2(G1, G3_fixed);
        ENV{3} = tt_env_mode3(G1, G2_fixed);

        KRP = {};
        for n = 1:N
            KRP{n} = ENV{n}(Unique_nz_col{n}, :);
        end

        Optimal_Trans = {};

        for n = 1:N

            rank_n = size(Factors{n}, 2);

            OT = Update_OT_tt( ...
                X_mat{n}, ...
                Unique_nz_col{n}, ...
                rank_n, ...
                K{n}, ...
                options, ...
                Factors{n}, ...
                KRP{n}, ...
                PARFOR);

            Optimal_Trans{n} = OT';

        end

        G1 = Update_G1_only_tt( ...
            G1, ...
            G2_fixed, ...
            G3_fixed, ...
            Optimal_Trans, ...
            Unique_nz_col);

        G1 = max(G1, 1e-12);

    end

    G1_test = G1;

end

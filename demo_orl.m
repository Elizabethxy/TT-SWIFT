clc;
clear all;
close all;

root_path = fileparts(mfilename('fullpath'));

base_path = fullfile(root_path, 'data');
train_path = fullfile(base_path, 'train');
test_path = fullfile(base_path, 'test');
result_path = fullfile(root_path, 'results');
sweep_path = result_path;

if ~exist(sweep_path, 'dir')
    mkdir(sweep_path);
end

addpath(fullfile(root_path, 'TT-SWIFT'));
assert(exist('sptensor','file') ~= 0, 'Install Tensor Toolbox and add it to the MATLAB path first.');

COST = {};
COST{1} = dlmread(fullfile(train_path, 'C1_train.csv'));
COST{2} = dlmread(fullfile(base_path, 'C2.csv'));
COST{3} = dlmread(fullfile(base_path, 'C3.csv'));

COST{1} = max(COST{1}, 0);
COST{2} = max(COST{2}, 0);
COST{3} = max(COST{3}, 0);

X_train = read_input_count_tt([train_path filesep], 'Tensor_train.csv');
X_test = read_input_count_tt([test_path filesep], 'Tensor_test.csv');

C1_test = dlmread(fullfile(test_path, 'C1_test.csv'));
C1_test = max(C1_test, 0);

PARFOR_FLAG = 0;
ranks = [100, 100];

% Parameters use the notation in the TT-SWIFT algorithm.
options.rho = 30;
options.lambda1 = 0.3;
options.lambda2 = 0.3;
options.Total_iteration = 1500;
options.sinkhorn_iter = 300;

seed_train = 1;
seed_test = 2;

fprintf('\n===== TT-SWIFT supplemental run: ranks=[%d,%d] =====\n', ranks(1), ranks(2));

output_tt = SWIFT_tt(X_train, ranks, COST{1}, COST{2}, COST{3}, options, seed_train, PARFOR_FLAG);

G1_train = output_tt.G1;
G2_train = output_tt.G2;
G3_train = output_tt.G3;

G1_test = project_G1_swift_tt( ...
    X_test, ...
    G2_train, ...
    G3_train, ...
    ranks, ...
    C1_test, ...
    COST{2}, ...
    COST{3}, ...
    options, ...
    seed_test, ...
    PARFOR_FLAG);

tag = sprintf('r%d_%d_rho%g_lam1%g_lam2%g_iter%d_sink%d', ...
    ranks(1), ranks(2), options.rho, options.lambda1, options.lambda2, ...
    options.Total_iteration, options.sinkhorn_iter);
tag = strrep(tag, '.', 'p');

writematrix(G1_train, fullfile(sweep_path, 'G1_train.csv'));
writematrix(G1_test, fullfile(sweep_path, 'G1_test.csv'));
save(fullfile(sweep_path, ['trained_cores_' tag '.mat']), ...
    'G1_train', 'G1_test', 'G2_train', 'G3_train', 'ranks', 'options');

fprintf('\nTT-SWIFT ranks=[%d,%d] G1_train size: [%d, %d]\n', ...
    ranks(1), ranks(2), size(G1_train, 1), size(G1_train, 2));
fprintf('TT-SWIFT ranks=[%d,%d] G1_test size:  [%d, %d]\n', ...
    ranks(1), ranks(2), size(G1_test, 1), size(G1_test, 2));
fprintf('Saved TT-SWIFT r=100 result to: %s\n', sweep_path);


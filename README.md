# TT-SWIFT

Three-way tensor decomposition with optimal transport updates, followed by
feature-based classification. Training learns TT cores G1, G2, and G3.
Test projection holds trained G2 and G3 fixed and updates only test G1.
Classification uses G1 features with fixed cosine and Manhattan 1-nearest
neighbor classifiers, without scaling or PCA.

## Requirements

- MATLAB with Tensor Toolbox installed and added to the MATLAB path.
- Python with dependencies installed using `python -m pip install -r requirements.txt`.

Tensor Toolbox is an external dependency and is not bundled. The demo uses
serial updates (`PARFOR_FLAG = 0`).

## Run

1. Prepare inputs following [data/README.md](data/README.md).
2. Open this directory in MATLAB and run `demo_orl`.
3. Run `python classify.py`.

The demo writes `results/G1_train.csv`, `results/G1_test.csv`, and a MAT
checkpoint containing the cores and parameters. Running it again overwrites
the feature CSVs. The Python script prints both test accuracies.

Default settings reproduce the configuration of the existing ORL experiment:
TT ranks [100, 100], rho=30, lambda1=lambda2=0.3, 1500 outer iterations,
300 Sinkhorn iterations, training seed 1, and projection seed 2. This is a
long-running configuration. Edit `demo_orl.m` to change parameters.

## Source files

| File | Purpose |
| --- | --- |
| demo_orl.m | Train, project test samples, and export features |
| classify.py | Evaluate fixed cosine and Manhattan 1NN classifiers |
| TT-SWIFT/SWIFT_tt.m | Main training loop |
| TT-SWIFT/Update_OT_tt.m | Sinkhorn-based transport updates |
| TT-SWIFT/Update_factor_tt.m | Update all three training cores |
| TT-SWIFT/KL_update_rule_tt.m | Multiplicative update rule |
| TT-SWIFT/tt_transport_parameters.m | Resolve rho, lambda1, lambda2 and derived exponents |
| TT-SWIFT/project_G1_swift_tt.m | Project test data with G2 and G3 fixed |
| TT-SWIFT/Update_G1_only_tt.m | Update only the sample core |
| TT-SWIFT/tt_env_mode1.m | Mode-1 environment matrix |
| TT-SWIFT/tt_env_mode2.m | Mode-2 environment matrix |
| TT-SWIFT/tt_env_mode3.m | Mode-3 environment matrix |
| TT-SWIFT/tt_core2_to_mat.m | Convert G2 to matrix form |
| TT-SWIFT/mat_to_tt_core2.m | Convert matrix form back to G2 |
| TT-SWIFT/unique_col_ind_tt.m | Find nonzero unfolding columns |
| TT-SWIFT/read_input_count_tt.m | Read sparse tensor CSV files |

## Provenance

This implementation was adapted from the existing SWIFT research code in
the local 2021_AAAI_SWIFT_codes project. Original attribution and license
terms should be verified and included before public distribution. No new
license is assigned by this packaging step.

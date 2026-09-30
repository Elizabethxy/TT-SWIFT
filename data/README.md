# Input data

Place prepared ORL inputs in this directory:

```text
data/
  C2.csv
  C3.csv
  train/
    Tensor_train.csv
    C1_train.csv
    labels_train.csv
  test/
    Tensor_test.csv
    C1_test.csv
    labels_test.csv
```

All CSV files are numeric, without headers. Tensor files contain four columns:
`i1,i2,i3,value`, with MATLAB one-based indices. Mode 1 represents samples.
The current reader infers dimensions from maximum indices, so each intended
dimension must be represented in the index columns. Train and test must use
the same mode-2 and mode-3 dimensions.

Cost matrices are square: C1_train is n_train by n_train, C1_test is n_test
by n_test, C2 is I2 by I2, and C3 is I3 by I3. Labels contain one value per
sample, ordered consistently with mode-1 indices. Costs are clipped at zero
by the demo. Data and trained models are not bundled with this repository.

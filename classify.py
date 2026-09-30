"""Evaluate TT-SWIFT features with fixed 1NN classifiers."""
from pathlib import Path

import numpy as np
from sklearn.metrics import accuracy_score
from sklearn.neighbors import KNeighborsClassifier


def main():
    root = Path(__file__).resolve().parent
    train = np.loadtxt(root / "results/G1_train.csv", delimiter=",", ndmin=2)
    test = np.loadtxt(root / "results/G1_test.csv", delimiter=",", ndmin=2)
    y_train = np.loadtxt(root / "data/train/labels_train.csv", delimiter=",").reshape(-1)
    y_test = np.loadtxt(root / "data/test/labels_test.csv", delimiter=",").reshape(-1)
    if train.shape[0] != y_train.size or test.shape[0] != y_test.size:
        raise ValueError("Feature rows must match label counts.")
    if train.shape[1] != test.shape[1]:
        raise ValueError("Training and test feature dimensions must match.")
    for metric in ("cosine", "manhattan"):
        model = KNeighborsClassifier(n_neighbors=1, metric=metric)
        model.fit(train, y_train)
        predictions = model.predict(test)
        print(f"1NN {metric}: {100 * accuracy_score(y_test, predictions):.2f}%")


if __name__ == "__main__":
    main()

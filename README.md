Saliency-Benchmark
==================

State-of-the-art Spectral Saliency Detection Models on state-of-the-art Datasets.

Installation
============

1. In `Datasets/GroundTruth/` and `Datasets/Images/`, I only put two example images in each dataset folder. If you want to test on the real datasets, you need to replace them.
2. Run `./SaliencyBenchmark.m` to generate saliency maps for all the models on all the datasets, the results are saved in `./SaliencyMaps/`.
3. Run `./benchPR.m` to save Precision and Recall results in `./Results/pr/`.
4. Run `./benchPRF.m` to save Precision, Recall and F-measure results in `./Results/prf/`.
5. Run `./drawPR.m` to show pr curves on all the datasets.
6. Run `./drawPRF.m` to show histogram of Precision, Recall and F-measure results on all the datasets.

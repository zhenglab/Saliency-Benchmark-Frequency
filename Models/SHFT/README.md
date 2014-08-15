Saliency-AAASA
==============

Detecting Salient Objects via Automatic Adaptive Amplitude Spectrum Analysis.

Installation
============

1. Choose the data set that you want to test, then copy the stimulli of the data set to `./DATASET_STIMULI/`.
2. Build a new folder to reserve the saliency map results.(eg, `./evaluation/DATASET_SaliencyMaps`)
3. Update `./SHFT_DATASET.m`: INPUTDATASET, EXTENSION, OUTPUTSM;
4. Run `./SHFT_DATASET.m` to generate the saliency maps on a given data set.

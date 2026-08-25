# S-VIF Image Quality Assessment

This repository contains the original MATLAB implementation associated with the following paper:

> Kuo, Tien-Ying, Po-Chyi Su, and Cheng-Mou Tsai,  
> **Improved visual information fidelity based on sensitivity characteristics of digital images.**  
> *Journal of Visual Communication and Image Representation*, vol. 40, pp. 76–84, 2016.

https://www.sciencedirect.com/science/article/pii/S104732031630102X

## Abstract

Digital images may lose certain information during transmission or transcoding processes. Since the lost information can influence the visual quality perceived by the human eyes, several quality assessment metrics have been proposed. The structural similarity index (SSIM) and visual information fidelity (VIF) are two of the most common methods that take characteristics of the human perceptual system into account. Although many improved metrics based on SSIM have been developed, the methods related to VIF, which outperforms SSIM-based approaches in certain image databases, have rarely been discussed. This research aims at improving VIF to increase the effectiveness and reduce its computational complexity. The enhanced VIF employs the Haar wavelet transform, log-Gabor filter, and spectral residual approach to emphasize the visual sensitivity in image quality assessment. The experimental results demonstrate the superior performance of the proposed method, when compared to various popular or latest assessment indices.

## Setup

Download this repository and download the required image quality assessment datasets separately.

Place the datasets under:

```text
ImageDatabase/
├── A57/
├── CSIQ/
├── IVC/
├── LIVE/
├── MICT/
├── TID2008/
└── WIQ/
```

The dataset directory structure should match the paths provided in:

```text
ImageDatabase/database_path/
```

## Getting Started

Run:

```matlab
batch
```

The script evaluates the configured datasets and stores the objective quality scores in the corresponding folders under:

```text
results/
```

## Performance Evaluation

After running `batch.m`, enter the corresponding dataset folder under `results/` and run:

```matlab
performance
```

For example:

```matlab
cd results/A57
performance
```

The evaluation includes the following performance metrics:

- SRCC
- KRCC
- PLCC
- RMSE

After execution, the evaluation metrics are stored in the MATLAB Workspace as `SRCC`, `KRCC`, `PLCC`, `RMSE`, and `metrics`.

## Citation

If you use this code in your research, please cite:

```bibtex
@article{kuo2016svif,
  title={Improved visual information fidelity based on sensitivity characteristics of digital images},
  author={Kuo, Tien-Ying and Su, Po-Chyi and Tsai, Cheng-Mou},
  journal={Journal of Visual Communication and Image Representation},
  volume={40},
  pages={76--84},
  year={2016}
}
```
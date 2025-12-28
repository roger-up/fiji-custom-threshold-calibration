# Fiji/ImageJ Batch Thresholding with Empirical Calibration

This repository contains a Fiji (ImageJ) macro designed to automate image binarization using a custom-calibrated thresholding method. 

## The Methodology: Why this script?

Standard automated methods like **Otsu** are powerful but sometimes fail to capture the fine details required in specific datasets (due to noise, low contrast, or varying lighting conditions). 

To solve this, I implemented a **Semi-Automated Calibration Workflow**:

1. **Manual Sampling:** I manually adjusted the threshold on several representative images from the dataset to achieve the "Ground Truth" segmentation (visual validation).
2. **Correlation Analysis:** I compared these manual values against the standard Otsu values calculated for the same images.
3. **Linear Correction:** Using the relationship between the two, I derived a linear equation ($y = mx + b$) to correct the Otsu threshold automatically across the rest of the dataset.



[Image of a linear regression plot]


## How it works

The script applies the following logic for each image in a folder:
1. Calculates the **Otsu Dark** threshold ($T_{Otsu}$).
2. Applies the empirical correction:
   
   $$T_{final} = 0.7 \times T_{Otsu} + 72.3$$

3. Converts the image to a binary mask and saves it in `.BMP` format (compatible with analysis software like CTAn).

## How to use
1. Open **Fiji/ImageJ**.
2. Run the `.ijm` file.
3. Select your input and output directories when prompted.

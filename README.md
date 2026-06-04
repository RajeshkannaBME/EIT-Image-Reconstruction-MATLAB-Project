Separation of Ventilation and Perfusion in Electrical Impedance Tomography (EIT)
A Validation Study using PCA, FFT, and EIDORS

This project was developed as part of the Forschungspraktikum (Summer Semester 2025) at Hochschule Furtwangen University (HFU) by:

Rajesh Kanna Dhanasekhar
Sujitha Shanmugasundharam
Juliet Merin Kalarikkal

The project focuses on separating lung ventilation and cardiac perfusion signals from Electrical Impedance Tomography (EIT) data and reconstructing individual images for each physiological process using the EIDORS toolbox.

📌 Project Overview

Electrical Impedance Tomography (EIT) is a non-invasive imaging technique that measures changes in thoracic electrical conductivity. Although primarily used for lung monitoring, EIT also contains information about cardiac activity.

The challenge is that respiratory and cardiac signals overlap in the recorded voltage measurements. This project introduces a signal processing pipeline that separates these components before image reconstruction.

The proposed workflow combines:

Principal Component Analysis (PCA)
Fast Fourier Transform (FFT)
Harmonic Analysis
EIDORS Image Reconstruction
Tikhonov Regularization
Singular Value Decomposition (SVD)

to generate independent ventilation and perfusion images.

🎯 Objectives
Process raw multi-channel EIT voltage data.
Extract dominant physiological frequencies.
Separate respiratory and cardiac signals.
Reconstruct independent EIT images.
Improve image quality using regularization.
Automate analysis for multiple subjects.
📂 Dataset

The project uses the publicly available Respiratory and Heart Rate Monitoring Dataset from PhysioNet.

Dataset contents:

.eit files (208-channel boundary voltage measurements)
.bin files (32×32 image frames)
Multiple breathing trials from 20 healthy subjects

The global impedance signal is extracted from .bin images and used for segment selection and apnea detection.

⚙️ Methodology
1. Dataset Preparation
Load EIT recordings
Extract global impedance curves
Identify suitable breathing and apnea segments
2. Principal Component Analysis (PCA)

PCA is applied to the 208-channel voltage measurements to reduce dimensionality and isolate dominant physiological components.

Features:

Top principal components extracted
Noise reduction
Signal separation
3. Fast Fourier Transform (FFT)

FFT is performed on PCA components to identify frequency peaks:

Signal	Frequency Range
Respiration	0.2 – 0.5 Hz
Cardiac Activity	0.8 – 1.2 Hz

These frequency bands are used to construct:

Vi_resp (Respiratory dataset)
Vi_card (Cardiac dataset)

4. Signal Filtering

Filtered datasets are generated using:

FFT Magnitude (abs)
FFT Phase (angle)
Harmonic analysis

The filtered signals improve separation between ventilation and perfusion.

5. Image Reconstruction (EIDORS)

The EIDORS MATLAB toolbox is used for image reconstruction.

The workflow includes:

Build inverse model
Generate reference voltage (vh)
Compute difference voltages
Solve inverse problem

The reconstructed images are interpolated to a 32×32 grid to visualize lung and heart activity separately.

6. Tikhonov Regularization

To stabilize the inverse solution, Tikhonov regularization is applied:

Reduces reconstruction noise
Improves image robustness
Optimizes sharpness

Singular Value Decomposition (SVD) is incorporated for ridge regression-based tuning.

Best performance was observed around:

α = 1 × 10⁻⁴

7. Batch Processing Automation

The complete pipeline is automated for all participants and breathing trials.

The automated framework performs:

Signal extraction
Frequency detection
Image reconstruction
Validation
Summary generation

This significantly reduces manual processing time while maintaining consistency across datasets.

📊 Results

The proposed method successfully:

✅ Separated ventilation and perfusion signals.

✅ Reconstructed anatomically meaningful lung and cardiac images.

✅ Produced images consistent with reference .bin frame differences.

✅ Improved reconstruction quality through optimized regularization.

Magnitude-based FFT reconstruction provided the clearest visualization, while phase-based methods were generally more sensitive to noise.

📁 Project Structure
EIT-Image-Reconstruction/
│
├── data/
│   ├── *.eit
│   ├── *.bin
│
├── src/
│   ├── dataset_preparation.m
│   ├── pca_analysis.m
│   ├── fft_analysis.m
│   ├── signal_filtering.m
│   ├── image_reconstruction.m
│   ├── tikhonov_regularization.m
│   ├── batch_automation.m
│
├── results/
│   ├── ventilation_images/
│   ├── cardiac_images/
│   ├── plots/
│
├── README.md
└── requirements.txt
🛠️ Requirements
MATLAB R2022a or newer
EIDORS Toolbox
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
🚀 How to Run
Install MATLAB.
Install and add EIDORS to the MATLAB path.
Download the PhysioNet EIT dataset.
Place the dataset inside the data/ folder.
Run the main pipeline:
main.m

or execute individual modules:

dataset_preparation
pca_analysis
fft_analysis
signal_filtering
image_reconstruction
batch_automation
🔬 Applications
Bedside lung monitoring
Ventilation/Perfusion (V/Q) assessment
Critical care monitoring
Non-invasive cardiac monitoring
Biomedical signal processing research
📚 References
Frerichs et al., Chest Electrical Impedance Tomography Examination, Thorax, 2017.
Putensen et al., Electrical Impedance Tomography for Cardio-Pulmonary Monitoring, 2019.
Battistel et al., Separation of Respiration and Perfusion in EIT by Harmonic Analysis, 2021.
Stein et al., Voltage-based Separation of Respiration and Cardiac Activity by Harmonic Analysis in EIT, 2024.
Adler & Boyle, Electrical Impedance Tomography: Tissue Properties to Image Measures, 2017.

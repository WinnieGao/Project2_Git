# Project 2 Cloud Data

## Task
The goal of this project is the exploration and modeling of cloud detection in the polar regions based on radiance recorded automatically by the MISR sensor abroad the NASA satellite Terra. We attempt to build a classification model to distinguish the presence of cloud from the absence of clouds in the images using the available signals/features. Our dataset has “expert labels” that can be used to train ourr models.

## Data
1. 3 image data sets with "Expert label” for model training
2. Features
   a. NDAI, SD, CORR (features based on subject knowledge)
   b. DF, CF, BF, AF, AN (row features)
   
## Image
The images under this repository was created by two Rmd files. The images in our final write-up is fixed.
   
## Data Processing
In our report, we come up with two totally different splitting methods, which are separately run in two Rmd files. Method1.Rmd corresponds to the first method and Method2.Rmd corresponds to the second. 

## Classification Model
1. KNN
2. GLM
3. LDA
4. QDA
5. SVM
6. RandomForest

We train all 6 models on two differently splitted data. We use accuracy and precision to evaluate the performances of our models. 

## Write-up
Our final report is compiled as Report.pdf by Report.Rnw using Latex. Download Report.Rnw and click "compile pdf" to get recompile. There is no code in Report.Rnw. All code are in two Rmd files. 






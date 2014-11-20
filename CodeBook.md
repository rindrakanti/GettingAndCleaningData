####This file describes the variables, the data, and any transformations that I have performed to clean up the data.
The site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#### The code in run_analysis.R is organized into multiple functions. 
#### The Main function invokes rest of the functions to achieve the results.

#### The run_analysis.R script performs the following steps to clean the data: 

1. The Main function calls the download.data function which downloads the data from the following URL to the “data” folder in the current directory. 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 
After downloading the compressed file successfully, files are extracted to the “data” folder in the current directory.

2. The Main function now calls the function merge.datasets which reads X_train.txt, y_train.txt and subject_train.txt from the "./data/UCI HAR Dataset/train" folder 
and stores them in training.x, training.y and training.subject variables respectively. 
Reads X_test.txt, y_test.txt and subject_test.txt from the "data/UCI HAR Dataset/test" folder and stores them in test.x, test.y and test.subject variables respectively.

3. The function merge.datasets then joins training.x with test.x to generate a 10299x561 merged.x data frame; 
join training.y with test.y to generate a merged.y 10299x1 data frame; 
join training.subject with test.subject to generate merged.subject 10299x1 data frame. 
The function merge.datasets  function finally returns a list three data frames to Main function which is stored in a variable called merged.

4. The Main function now calls the function extract.mean.and.std that takes the merged dataframe as the input. 
Reads the features.txt file from the "data" folder and store the data in a variable called features. 
Uses sapply looping function to extract the measurements on the mean and standard deviation that we are interested. 
This results in a 66 indices list. The function then applies the logical vectors on the input dataframe for subsetting and returns a data frame of 10299x66. 
The Main function stores the dataframe returned by extract.mean.and.std in a variable called cx.

5. The Main function now invokes the function called name.activities, which takes activities dataframe named df as the input and returns the modified dataframe. 
Using subsetting, the function identifies the appropriate rows for each of the 6 activities in the dataframe and assigns them with respective activity names. 
The Main function stores the modified activity dataframe returned by nam.activities function in a variable called cy.

6. The Main function now assigns “subject” as the column name for the ‘subject’ dataframe in the merged list.

7. The Main function now calls the function bind.data with three dataframes called cx, cy and merged$subject as the input. 
The function bind.data joins the three dataframes using cbind and returns the merged dataframe to the Main function with 10299x68, which is stored in a variable called combined. 
The "subject" column contains integers; the "activity" column contains 6 kinds of activity names; the first 66 columns contain measurement data.

8. The Main function now writes the combined dataframe to "merged_data.txt" file in the working directory.

9. The Main function now calls the function called create.tidy.dataset which takes dataframe df as the input and returns a dataframe called tidy. 
The function create.tidy.dataset uses the ddply function which takes dataframe called df as input and 
applies the anonymous function that calculates mean values for the first 60 columns of the dataframe df and returns the results in a dataframe called tidy.

10. The Main function now writes the tidy dataframe to "tidy_data.txt" file in the working directory.

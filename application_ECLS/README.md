# Replication of Application: Test Scores in Early Childhood

# Getting the Data 
1. Go to https://nces.ed.gov/ecls/dataproducts.asp and download the Electronic Codebook software (requires Windows system)
2. Install the software, instructions could be found in chapter 8 of the user manual https://nces.ed.gov/pubsearch/pubsinfo.asp?pubid=2019051
3. Select the variables from the left panel and export to the right panel, we focus on math scores and their standard errors
4. Click Extract with STATA option. This will give the .dct and .do files to generate the data 
5. Run the script to generate the data, resulting in a .dta file

# Processing the Data 
This is done in education_data_processing.R

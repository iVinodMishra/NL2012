README

This zip file contains Stata program for estimating Narayan and Liu (2013) test. The do file "GARCH_UR_SEQ.do" reads data from "nifty.dta" file and generates the log file, "GARCH_UR_SEQ.smcl" that contains the results. The results are also displayed on the output window of Stata. If you extract the contents of this zip file in one folder and set Stata working directory to that folder; the code should run without any problems. 

I have commented the do file as much as possible, however, please make note of the following points:

1.  Set the name of variable of interest as X. All the coding is based on name X. It is better to change the name of variable to X in the beginning, instead of changing all the occurrence of X in the program with a different variable name. 

2. Create a variable "t" that indexes for time (already created in the attached data file); such that t = 1 for first time period, t = 2 for second time period ...and so on. Use this variable to "tsset" the data. The codes is written with this generic specification of time for the dataset. 

3. The breaks dates will be reported in terms of "t", however, you can always look at the mapping of "t" with calendar time and report break-dates in terms of calendar time. 

4. When you run this code, it will generate a lot of results, however, the final result will be reported at the end under the heading "*** Final Results ***". Please note the code does not generate the critical values for the Unit Root Test Statistics. You will need to lookup the critical values in original Narayan and Liu paper. 

5. On line 60 of the do file, the "minimum gap between the breaks" is set. In the attached file this value is set at 5 (i.e. the two breaks have to be at-least 5 times periods apart). Please change this to a value appropriate to your dataset. 

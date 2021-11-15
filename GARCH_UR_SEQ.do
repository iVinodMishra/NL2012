clear
clear matrix


# delimit;
set more off;
log using GARCH_UR_SEQ.smcl, smcl replace;

****************************************************************************************;
* Stata code for estimating the NL 2012 unir root test with 2 breaks in the intercept  *;
* using the Sequential Procedure													   *;
****************************************************************************************;
use test.dta;
tsset t;
/* Identifying the First Break date */
/* ----------------------------- -------------------------- ----------------- */

local tr = 0.20; /* Triming Region */
local T = _N-1;    /* Total observations */

count if X ==.;
local missing = r(N);

local tr2 = floor(`T' - (`tr'*`T')); 

display `tr2';

local tr1 = round(`T'-`tr2'+1) + `missing' ; 

display `tr1';

matrix matB1 = 0,0; 

/* Search for Break 1 */
forvalues TB1 = `tr1'(1)`tr2' {;

display `TB1';

	quietly gen B1 = 1 if t >= `TB1';
	quietly replace B1 = 0 if B1 ==.;

	quietly arch D.X L.X B1, arch(1/1) garch(1/1);

	matrix matB1 = matB1 \ (`TB1', abs(_b[B1]/_se[B1]));

	drop B1;

};


mata : st_matrix("matB1", sort(st_matrix("matB1"), 2)); 
mat matB1 = matB1[rowsof(matB1),1..2]; 
matrix list matB1;

local TB1_L = matB1[1,1]; 
local TB1_T = matB1[1,2]; 

/* Identifying the Second Break date - given the location of first break date */
/* ----------------------------- -------------------------- ----------------- */
gen B1 = 1 if t >= `TB1_L';
replace B1 = 0 if B1 ==.;

matrix matB2 = 0,0; 

/* Search for Break 2 */
forvalues TB2 = `tr1'(1)`tr2' {;
	if abs(`TB2' - `TB1_L') >= 5 {; /* This will ensure that break dates are at least 5 periods apart */ 
		
		quietly gen B2 = 1 if t >= `TB2';
		quietly replace B2 = 0 if B2 ==.;
		quietly arch D.X L.X B1 B2, arch(1/1) garch(1/1);
		matrix matB2 = matB2 \ (`TB2', abs(_b[B2]/_se[B2]));
		drop B2;
	};
};

mata : st_matrix("matB2", sort(st_matrix("matB2"), 2)); 
mat matB2 = matB2[rowsof(matB2),1..2];
matrix list matB2;

local TB2_L = matB2[1,1]; 
local TB2_T = matB2[1,2]; 

drop B1;

/* Estimating the final GARCH(1,1) model based on both the breaks */
/* ----------------------------- -------------------------- ----------------- */
quietly gen B1 = 1 if t >= `TB1_L'; 
quietly replace B1 = 0 if B1 ==.;
quietly gen B2 = 1 if t >= `TB2_L'; 
quietly replace B2 = 0 if B2 ==.;

arch D.X L.X B1 B2, arch(1/1) garch(1/1);

matrix matBF = matB1 \ matB2; 
mata : st_matrix("matBF", sort(st_matrix("matBF"), 1)); 

display "************************ Final Results **************************";
display "Series : " "`var'";
display "Trimming value :" `tr' "(" `tr1' "-" `tr2' ")";
display "Break Dates             t-statistics";
matrix list matBF;
display "Unit Root Test Statistics";
display _b[L1.X]/_se[L1.X];
display "************************ Final Results **************************";

drop X B1 B2;

****************************************************************************************;
* Clearing and closing the log file													   *;
****************************************************************************************;
log close;

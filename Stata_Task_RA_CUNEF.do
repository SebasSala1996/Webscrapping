*Date of creation: 28/04/2025 10:18CET
*Author: Juan Sebastian Salazar
*Scope: RA Position CUNEF Technical Task

*Stata Task

*General commands
**Set the workspace
cd "C:\Users\SEBASTIAN\Documents\tosend"
**Set scheme for Visuals 
set scheme tufte

*1. Using the employed.dta dataset:
use "employed", replace
**1.a. Plot a histogram of the logarithm of labor income (labor income) by area type (area type).

*Step 1 - Create log of labor income 
gen log_labor_income = log(labor_income)
*Step 2 - Plot histograms by area type
**For Urban
histogram log_labor_income if area_type == 1, ///
    width(0.2) ///
    color(gs14) ///
    xtitle("Log Labor Income") ///
    ytitle("Frequency")
**For Rural
histogram log_labor_income if area_type == 2, ///
    width(0.2) ///
    color(gs10) ///
    xtitle("Log Labor Income") ///
    ytitle("Frequency")
	
**1.b. Plot a box plot of the hours per week worked (hours per week) over type of contract (type contract).

*Step 1 - Box plot of hours per week worked over type of contract
graph box hours_per_week, over(type_contract, sort(1) label(angle(45))) ///
    ytitle("Hours per Week Worked") 
	
**1.c. Report the number of workers and the mean and standard deviation of labor income by type of worker.

*Step 1 - Import estout for exporting the table to LaTex
ssc install estout, replace
*Step 2 -  Generate summary statistics for labor_income by type_of_worker
estpost tabstat labor_income, by(type_of_worker) stats(mean sd n)
*Step 3 -  Export to LaTeX
esttab using "summary_by_type_worker.tex", ///
    cells("mean(fmt(2)) sd(fmt(2)) count(fmt(0))") ///
    label ///
    replace ///
    title("Summary Statistics of Labor Income by Type of Worker") ///
    nonumber ///
    nomtitle ///
    noobs ///
    varwidth(20)
	
**1.d. Cross-tabulate the type of contract with the indicator of those who want to work more hours. (see data dictionary at the end of the document). Show the proportion by type of worker. 
	*Note - I'm using Stata 16, hence the table command doesn't allow to use statistics command. I'll need to do some manual steps to create a hierarchy.
	
*Step 0 - Preserve original data
preserve
*Step 1 - Create a helper variable
generate one = 1
*Step 2 - Collapse the data
collapse (sum) one, by(type_of_worker type_contract want_more_hours)
*Step 3 - Create totals and percentages
egen total_worker_contract = total(one), by(type_of_worker type_contract)
gen percent = 100 * one / total_worker_contract
*Step 4 - List the result 
list type_of_worker type_contract want_more_hours one percent, sepby(type_of_worker type_contract)
*Step 5: Restore the original full dataset
restore

*2. Using the unemployed.dta dataset:
use "unemployed", replace

**2.a. Create numeric variables that codify unemployment subsidy (d unemployment subsidy) and retirement resources dummy variables (d retirement resources s* ). See the data dictionary for more information on these variables.

*Step 1 - Codify Unemployment Subsidy
gen d_unemployment_subsidy_num = .
replace d_unemployment_subsidy_num = 1 if d_unemployment_subsidy == "Yes"
replace d_unemployment_subsidy_num = 0 if d_unemployment_subsidy == "No"
label variable d_unemployment_subsidy_num "Receives Unemployment Subsidy (1=Yes, 0=No)"

*Step 2 - Codify Retirement Resources Dummy Variables using a forloop
local retirement_vars d_retirement_resources_s1 d_retirement_resources_s2 d_retirement_resources_s3 ///
                       d_retirement_resources_s4 d_retirement_resources_s5 d_retirement_resources_s6 d_retirement_resources_s7

foreach var of local retirement_vars {
    
    // Create a new variable name
    local newvar = "`var'_num"
    
    // Generate empty numeric version
    gen `newvar' = .
    
    // If original variable is "Yes", recode
    replace `newvar' = 1 if `var' == "Yes"

    // Optional: label new variable
    label variable `newvar' "`var' (1=Yes)"
}

**2.b. Unemployed people were asked to determine, in case of illness, how they would cover medical and medication costs. Their answers are in the illness cost variable. You can find the possible responses in the dataset directory. Label variable illness cost using the possible responses.

// Define label for illness_cost
label define illness_cost_lbl ///
    1 "Affiliated with a subsidized regime" ///
    2 "Beneficiary of an affiliate" ///
    3 "With personal savings" ///
    4 "With help from children or relatives" ///
    5 "With other types of insurance or coverage" ///
    6 "Borrowing money" ///
    7 "Has not considered it" ///
    8 "Has no resource" ///
    9 "Other"

// Apply label to variable
label values illness_cost illness_cost_lbl

**2.c. Save the data set (with labels and categories) you create unemployed created.dta. You will use it in the next steps.

save unemployed_created.dta, replace

**2.d. Create a new database with the number of unemployed and the mean of weeks spent looking for a new job per type of area (urban and rural) by month. Make (i) a connected line graph showing the total number of unemployed people by type of area in each month (you should label the month variable) and (ii) the same type of plot but with mean weeks looking for a new job.

use unemployed_created.dta, clear

*Step 0 - Preserve original data
preserve
*Step 1 - Collapse dataset correctly
collapse (count) n_unemployed=weeks_looking (mean) mean_weeks=weeks_looking, by(area_type month)
*Step 2 - Label month safely
capture label define month_lbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                      7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values month month_lbl
*Step 3 - Line graph (Number of Unemployed)
twoway (line n_unemployed month if area_type==1, lpattern(solid) lcolor(blue)) ///
       (line n_unemployed month if area_type==2, lpattern(dash) lcolor(red)), ///
       ytitle("Number of Unemployed") ///
       xtitle("Month") ///
       legend(label(1 "Urban") label(2 "Rural")) ///
       xlabel(1(1)12, valuelabel angle(45))
*Step 4 - Line graph (Mean Weeks Looking)
twoway (line mean_weeks month if area_type==1, lpattern(solid) lcolor(blue)) ///
       (line mean_weeks month if area_type==2, lpattern(dash) lcolor(red)), ///
       ytitle("Mean Weeks Searching") ///
       xtitle("Month") ///
       legend(label(1 "Urban") label(2 "Rural")) ///
       xlabel(1(1)12, valuelabel angle(45))
*Step 5 - Restore original data
restore

*3. Append the data sets of employed and unemployed that you create in (2c). Recall that directory and sequence p is the household identifier and position is the individual identifier in each household.

*3.a. Save the final dataset as laborforce.dta.

*Step 1 - Load employed dataset
use employed.dta, clear
*Step 2 - Append with the unemployed dataset
append using unemployed_created.dta
*Step 3 - Save the final merged dataset
save laborforce.dta, replace

*3.b. Plot the unemployment rate over the states.

*Step 1 - Create employment status variable
generate unemployed = .
replace unemployed = 1 if missing(labor_income)
replace unemployed = 0 if !missing(labor_income)
label define employment_status 0 "Employed" 1 "Unemployed"
label values unemployed employment_status
*Step 2 - Preserve original data
preserve
// Step 3: Calculate unemployment rate by state
collapse (mean) unemployment_rate=unemployed, by(state)

*Step 3 - Plot unemployment rate
graph bar unemployment_rate, over(state, sort(1)) ///
    ytitle("Unemployment Rate") ///
    bargap(15) ///
    bar(1, color(blue))
*Step 4 - Restore original data
restore

*4. Merge laborforce.dta with dataset individuals.dta.

*4.a. Is it a perfect match? Why?

*Step 1 - Load laborforce.dta
use laborforce.dta, clear
*Step 2 - Merge with individuals.dta
**Note: Error deected when merge variable month is byte in master i.e., laborforce.dta but str2 in using data i.e., individuals. Hence, I'll correct it in individuals.
**Step 2.1 - import individuals.dta
use individuals.dta, clear
**Step 2.2 - Check how month looks
tabulate month
**Step 2.3 - Convert month to numeric
destring month, replace force
**Step 2.4 - Save Individuals with the changes
save individuals.dta, replace
*Step 3 - Now merge with laborforce.dta
use laborforce.dta, clear
merge 1:1 directory sequence_p position using individuals.dta
tabulate _merge
drop _merge

**4.b. In the sample, unemployed were asked What are you doing to obtain resources in case of retirement or for old age? The possible responses are in the data dictionary. Note that none of these options is exclusive. It means that some of them can be contributing to a voluntary pension fund and making investments at the same time. Plot the proportion of people with unemployment who think about retirement resources by sex.1 What is the most common source for each sex?

*Step 1 - Identify and keep only unemployed individuals
gen byte unemployed = missing(labor_income)
keep if unemployed == 1

*Note: I'll first save before doing the 4.b since I need to drop the employed

*4.c. Save the data set (with labels and categories) as individuals and laborforce.dta. You will use it in the next steps.

save individuals_and_laborforce.dta, replace

*Step 2 - Ensure retirement dummies are coded 1 for Yes, 0 for No
*Note: We need to recode missing to 0 explicitly.
foreach i in 1 2 3 4 5 6 7 {
    * If the variable doesn't exist, skip
    capture confirm variable d_retirement_resources_s`i'_num
    if !_rc {
        replace d_retirement_resources_s`i'_num = 0 if missing(d_retirement_resources_s`i'_num)
    }
    else {
        display as error "Variable d_retirement_resources_s`i'_num not found!"
        exit 1
    }
}

*Step 3 - Create unique ID for reshaping
gen long pid = _n

*Step 4 - Rename to generic stub1–stub7
rename d_retirement_resources_s1_num stub1
rename d_retirement_resources_s2_num stub2
rename d_retirement_resources_s3_num stub3
rename d_retirement_resources_s4_num stub4
rename d_retirement_resources_s5_num stub5
rename d_retirement_resources_s6_num stub6
rename d_retirement_resources_s7_num stub7

*Step 5 - Reshape to long format
reshape long stub, i(pid) j(resource)

*Step 6 - Clean up and label variables
rename stub used
label define resource_lbl 1 "Mandatory Pension" 2 "Voluntary Pension" ///
                         3 "Saving" 4 "Investments" 5 "Insurance" ///
                         6 "Support from Children" 7 "Other"
label values resource resource_lbl

*Step 7 - Preserve original data
preserve
*Step 8 - Collapse to get proportions by sex and resource
collapse (mean) used, by(sex resource)
rename used proportion

*Step 9 - Plot the grouped bar chart
graph bar proportion, ///
    over(resource, label(angle(45))) ///
    over(sex) ///
    bar(1, color(blue)) bar(2, color(red)) ///
    ytitle("Proportion Using Resource") ///
    blabel(bar, format(%4.2f)) ///
    legend(order(1 "Male" 2 "Female"))

*Step 10 - Find the most common source per sex
sort sex proportion
by sex: keep if _n == _N

list sex resource proportion, noobs clean

*Step 11 - Restore original data
restore


*5. Merge individuals and laborforce.dta with households.dta:

*Step 1 - Load the individuals + laborforce dataset
use individuals_and_laborforce.dta, clear
*Note: State is byte in master dataset, it should be change to do the merged
*Step 1.1 - Convert string state to numeric version
destring state, replace ignore(" ")
*Step 1.2 - Save corrected file
replace unemployed = 0 if missing(unemployed)
save individuals_and_laborforce.dta, replace
*Step 2 -  Merge with household-level dataset
merge m:1 directory sequence_p using households.dta
*Step 3 -  Check merge result
tabulate _merge
drop _merge
*Step 4 -  Save the dataset
save individuals_and_laborforce_and_household.dta, replace


*5.a. We want to know how many poor and extreme poor are unemployed and employed. For this, you need to collapse the dataset in such a way that you obtain a database where ‘employment status’ categories are in the rows and one column counts poor and the other counting extreme poor.
use individuals_and_laborforce_and_household.dta, clear
*Step 1 - Collapse — count of poor and extreme poor by employment status
collapse (sum) poor extreme, by(unemployed)
*Step 2 - Label for clarity
label define empstat 0 "Employed" 1 "Unemployed"
label values unemployed empstat
*Step 3 - Review result
list, noobs clean

*5.b. Invert the dataset matrix. This means that the columns should be the employment status and the rows should be the poor and extreme. What are the unemployment rates for the poor and the extreme poor?

*Step 2: Reshape to long format so we can transpose
gen id = _n
reshape long poor extreme, i(id) j(varname) string

*5.c. Using the dataset obtained in (5), create a variable that counts the number of unemployed and employed in each household. In addition, create a household identifier.

*Step 1 - Import the dataset from 5
use individuals_and_laborforce_and_household.dta, clear

*Step 2: Create a unique household identifier
gen household_id = string(directory) + "_" + string(sequence_p)

*Step 3 - Create employed flag from unemployed flag
gen employed = (unemployed == 0)

*Step 4 - Sum the number of employed and unemployed per household
bysort household_id: egen num_employed = total(employed)
bysort household_id: egen num_unemployed = total(unemployed)

*Save the resulting dataset
save ilh_employment_counts.dta, replace

*6.Using the dataset obtained in (5c),
*6.a. Create a summary statistics table including: log of labor income, sex, age, schooling, relationship with the head of household, number of unemployed, and the number of employed in the household.
*Step 1 - Create log of labor income
use ilh_employment_counts.dta, clear
gen log_labor_income = log(labor_income) if labor_income > 0
* Create a numeric gender variable: 1 = Male, 2 = Female
gen gender = .
replace gender = 1 if sex == "Male"
replace gender = 2 if sex == "Female"

* (Optional) Label the values for readability
label define gender_lbl 1 "Male" 2 "Female"
label values gender gender_lbl
*Step 2 - Create summary statistics
sum log_labor_income gender age schooling relationship_headhh num_unemployed num_employed 


ssc install reghdfe, replace
ssc install ftools, replace

* 1. Regress log labor income on sex only (Female dummy)
* Create the female dummy
gen female = (sex == "Female")

reghdfe log_labor_income female, absorb()

* 2. Create age squared
gen age2 = age^2

* 3. Run regression with more controls
reghdfe log_labor_income female age age2 i.schooling i.relationship_headhh, absorb()

*3. Add number of unemployed and employed in the household
reghdfe log_labor_income female age age2 i.schooling i.relationship_headhh num_unemployed num_employed, absorb()

*4. Add household fixed effects
reghdfe log_labor_income female age age2 i.schooling i.relationship_headhh num_unemployed num_employed, absorb(household_id)

*5. Add month fixed effects too
reghdfe log_labor_income female age age2 i.schooling i.relationship_headhh num_unemployed num_employed, absorb(household_id month)

* First regression: only female
reghdfe log_labor_income female, absorb()
eststo reg1

* Second regression: female + age + age2 + schooling + relationship
reghdfe log_labor_income female age age2 i.schooling i.relationship_headhh, absorb()
eststo reg2

* Third regression: adding num_employed and num_unemployed
reghdfe log_labor_income female age age2 i.schooling i.relationship_headhh num_unemployed num_employed, absorb()
eststo reg3

* Fourth regression: adding household fixed effects
reghdfe log_labor_income female age age2 i.schooling i.relationship_headhh num_unemployed num_employed, absorb(household_id)

eststo reg4

* Fifth regression: adding household + month fixed effects
reghdfe log_labor_income female age age2 i.schooling i.relationship_headhh num_unemployed num_employed, absorb(household_id month)
eststo reg5

* Now export only the coefficients you need
esttab reg1 reg2 reg3 reg4 reg5 using regression_table.tex, ///
    se label replace ///
    keep(female age age2 num_unemployed num_employed) ///
    title(Regression Results: Selected Coefficients) ///
    addnotes("All regressions absorb different fixed effects and controls progressively.")
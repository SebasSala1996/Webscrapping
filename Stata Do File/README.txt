File: Stata_Task_RA_CUNEF.do
Author: Juan Sebastian Salazar
Date: 28/04/2025
Purpose: This script was developed to complete a technical task for a Research Assistant position at CUNEF. It includes data wrangling, visualization, regression analysis, and merging operations across multiple datasets.

Contents Overview
General Setup

Sets the working directory.

Configures the visual scheme (tufte) for Stata graphs.

Section 1: Analysis using employed.dta

	1.a Creates and plots histograms of log labor income, separated by area type (urban and rural).

	1.b Generates a box plot of hours worked per week by contract type.

	1.c Computes summary statistics (count, mean, standard deviation) of labor income by type of worker.

	1.d Cross-tabulates contract type and the desire to work more hours, by type of worker.

Section 2: Analysis using unemployed.dta

	Creates binary variables for unemployment subsidy and retirement resource dummies.

Labels the variable for illness cost.

	Computes average job-seeking duration and unemployment count by area and month.

	Plots trends in unemployment and job search duration over time.

Section 3: Merging employed and unemployed datasets

	Appends both datasets into one (laborforce.dta) using individual identifiers.

	Plots unemployment rate by state.

Section 4: Merging with individuals.dta

	Merges individual-level data with laborforce data.

	Analyzes retirement resource preferences by gender.

	Saves the resulting dataset.

Section 5: Merging with households.dta

	Collapses data to report unemployment by poverty level (poor and extreme poor).

	Transposes this to analyze unemployment rates by income group.

	Counts employed and unemployed individuals per household.

Section 6: Regression and Summary Analysis

	Computes summary statistics for key variables.

	Runs 5 regressions on labor income (with progressively added controls and fixed effects).

	Exports selected coefficients into LaTeX format.

	Adds notes on the inclusion of controls (schooling, relationship, FE).

Note:
All plots, transformations, and tables are created following the analytical flow defined in the task instructions. The .do file is well-commented for clarity and modular execution.
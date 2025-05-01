File: Webscrapping.ipynb
Author: Juan Sebastian Salazar
Date: 28/04/2025
Purpose: This Jupyter notebook performs automated web scraping of Colombian school information from the Ministry of Education's website, using Selenium. It builds a dataset combining input Excel data with scraped results.

Contents Overview
Package Installation

Installs required Python packages:

	selenium: for browser automation

	webdriver-manager: to auto-install the appropriate ChromeDriver

Library Imports

	Imports Selenium components, pandas, time, and ActionChains for interaction and data handling.

Excel Data Loading

	Loads a local Excel file school-list.xlsx which contains a list of school Sede Codes and metadata.

Browser Setup

	Initializes a Selenium Chrome WebDriver using webdriver-manager.

	Configures browser settings (e.g., maximized window).

	Data Storage Setup

	Prepares an empty DataFrame and a list (scraped_rows) to store school attributes.

	Scraping Loop

		Iterates through the sede_code values.

		Navigates to the Ministry's advanced search page.

		Inputs the Sede Code, clicks the “Consultar” button.

		Clicks the first search result link.

		Extracts school data from a structured HTML table.

			Captures fields such as:

				School Name, DANE Code, Address, Phone, Department, Municipality, Calendar Type, Sector, Area, Gender, School Day, Dean.

	Error Handling

	Catches timeouts and invalid Sede Codes with try-except blocks.

	Skips entries with broken links or missing results.

Data Saving

	Merges scraped data with original school_df using sede_code as key.

	Saves the final dataset to a local file: merged_school_data.csv.

Notes:

	Script is structured for clarity and includes debug print statements.

	Initial test run is limited to 10 observations for validation.

	Web interactions simulate real user actions via ActionChains.


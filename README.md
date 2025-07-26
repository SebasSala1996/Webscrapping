# 🏫 Colombian Schools Web Scraper

A Python-based web scraping tool that extracts detailed school information from the Colombian Ministry of Education portal using official DANE codes.

---

## 📌 Project Overview

This tool automates the retrieval of school data from the official government site:

🔗 https://sineb.mineducacion.gov.co/bcol/app

Using a list of DANE codes, it navigates the search interface with **Selenium**, extracts key fields per school, and stores them in a structured pandas DataFrame.

---

## 🔍 What It Scrapes

For each school, the tool collects:
- ✅ School Name
- 🏙️ Municipality and State
- 📍 Address
- ☎️ Phone Number
- 🏫 Academic Level
- 📚 Educational Modalities
- 👥 Student Capacity
- 🔢 DANE Code
- 🏷️ School Type (Public/Private)
- 🌐 Web presence or registration status

---

## 🛠️ Tech Stack

| Component | Library |
|----------|---------|
| Scraping | Selenium, WebDriver Manager |
| Data | Pandas |
| Environment | Jupyter Notebook |
| Automation | Chrome WebDriver |

---

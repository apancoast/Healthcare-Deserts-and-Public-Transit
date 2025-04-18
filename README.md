## 📌 Project Overview
This dbt project analyzes the intersection of healthcare accessibility and public transit coverage in Mecklenburg County. The goal is to identify **healthcare deserts**—areas with limited access to medical services—and evaluate how public transit (or the lack thereof) affects healthcare accessibility.

By leveraging dbt, this project aims to transform raw datasets into actionable insights that can inform policymakers, transit agencies, and healthcare planners about disparities in access.
### Project Scope
Current project scope is limited to:
- Mecklenburg County, North Carolina
- Primary care health deserts
- Populations with public insurance
- Population demographics only include age ranges
- ~~Healthcare providers who are eligible to bill Medicaid/Medicare~~
- Public transit routes
### Outside of Project Scope
but potential to add:
- Public transit ridership numbers and demographics
- Demographics beyond age
- Additional healthcare needs, such as Mental Health and Dental

## 🏗️ Project Status

### 🚧 Project on Pause (April 2025)
Due to other life priorities, this project is currently on pause. However, I’m proud of the progress so far and the skills it demonstrates, including:
- Loading and staging raw data from S3 into DuckDB
- Developing modular dbt models for analytics and metric calculations
- Creating Python-based dbt models for API calls and data enrichment
- Documenting cleaning logic and ensuring consistency with data governance standards

It also highlights soft skills such as:
- Proactively identifying and addressing data quality issues
- Modeling with end-user analytics in mind
- Staying organized and intentional about technical debt during the build process

I look forward to returning to it when I can give it the attention it deserves.

### 🚀 Project Roadmap

| Milestone                                 | Status         |
| ----------------------------------------- | -------------- |
| Source dataset discovery and storage      | ✅ Completed    |
| dbt and Duckdb init                       | ✅ Completed    |
| Load raw datasets into staged layer       | ✅ Completed    |
| Comprehensive staging layer documentation | ✅ Completed    |
| Test and validate staging layer           | ✅ Completed     |
| Design analytical models                | ✅ Completed |
| Develop intermediate models to support mart layer                | ✅ Completed |
| Test and validate intermediate layer             | ⏳ Upcoming     |
| Develop mart layer models                | ✅ Completed  |
| Test and validate mart layer             | ⏳ Upcoming     |
| Prepare visualization                     | ⏳ Upcoming     |

### Change Log
| Change Decision                                | Reason         | Applied         |
| ----------------------------------------- | -------------- | -------------- |
| Exclude CMS and nearest source of care from analysis.    | Too time-consuming to determine Primary Care Providers from all providers in this iteration.   | 2025-02-27    |

## 🛠️ Let's Get Technical
### Tech Stack
 - Amazon S3
	 - Raw dataset storage
 - DuckDB
	 - S3 connector
	 - RDBMS
 - dbt
	 - Data transformation
	 - Documentation

Key dbt features implemented: 

	✅ Database connection via DuckDB  
	✅ Staging models for raw data processing  
	✅ Macros for reusable SQL logic  
	✅ Testing through dbt built-in features and packages  
	✅ Documentation through dbt

### Planned Final Outputs
- **Processed Datasets**: Available in a Tableau-ready format.
- **Interactive Maps**: Visualizing healthcare deserts and transit coverage.
- **Full dbt Documentation**: Generated from dbt models, including lineage graphs and data dictionaries, with supplemental information for a holistic data governance.

## 📢 Contact & Updates
For project updates and insights star the repo, follow my [LinkedIn](https://www.linkedin.com/in/pancoastashley/), or just keep refreshing this README like it’s your Instagram feed seconds after TikTok "left" the US.

## ✍️ Contributions
This project isn’t open for external contributions yet, but feel free to fork the repo for your own use. If you adapt it to another location, I’d love to hear about it!

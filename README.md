# SF Bay Area Bikeshare Data Analysis (SQL)
This project looks into a bike share data using MySQL to analyze usage patterns and user behaviors for different contexts.  
[Link to Tableau Dashboard](https://public.tableau.com/views/SFBikeShare_17065621499340/Dashboard1?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link)

### Data
[SF Bay Area Bike Share](https://www.kaggle.com/datasets/benhamner/sf-bay-area-bike-share) by Ben Busath on Kaggle, anonymized data from August 2013 to August 2015.

`station.csv` : information on stations where users pick up and return bikes.  
`trip.csv` : data on each trip, inlcuding start and end station/timestamp  
`status.csv` : data on number of bikes and docks available for given station and minute  
`weather.csv`: weather on specific day in certain zipcode  
</br> 

### Step 1: Data Prepartion
Columns with date were in MM/DD/YYYY format in the original .csv files.  
These columns had to be changed to YYYY/MM/DD for ease in later analysis.  
</br> 

### Step 2: Simple exploratory anlaysis
EDA for better understanding of the data.  
_e.g. Top 10 popular ride course, No. of trips by city_  
</br> 

### Step 3: Business context-specific analysis
More complicated queries using joins under reasonably assumed business contexts.  
_e.g. user behavior under different weather, $ charge by different user types_ 



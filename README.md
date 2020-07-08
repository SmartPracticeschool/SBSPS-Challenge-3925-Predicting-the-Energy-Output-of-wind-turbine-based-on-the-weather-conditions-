# Predicting Energy Output of Wind Turbine based on the Weather Conditions

##### app-release.apk is the APK of the app for direct use

## Description of Project
Wind energy plays an increasing role in the supply of energy world-wide. The energy output of a wind farm is highly dependent on the wind conditions present at its site. If the output can be predicted more accurately, energy suppliers can coordinate the collaborative production of different energy sources more efficiently to avoid costly overproduction.

## Solution Offered through this project
We analyzed the data for a Windmill Farm and extracted the weather parameters (assuming other physical conditions like weight of blades, height of windmill to be same etc) that affect power generation the most. Then we prepared an ML model taking the obtained features in consideration, using Boosted Regressor Tree Model. Then for provinding solution quicker to the end-user, we made an Android app to obtain power predictions of next 72 hours on hourly basis in single click.

## Software Development Life Cycle(SDLC) Model Used
We used Iterative SDLC model in making of this software. We made, tested and scraped many ML models before reaching this final model. For prototyping we also used MATLAB. App was also developed in many iterative steps with each iteration adding a certain feature to previous version. 

## Technology Stack Used
Jupyter Notebook (Python3) for Data Preprocessing, Python3 for ML model making and Flutter for front-end app development and Flask for back-end and integration with the model.

##### Climacell API key has been removed from app.py

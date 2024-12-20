* ==============================================
* Data Import and Preprocessing
* ==============================================

* Import the CSV file
import delimited "data.csv", clear
* Encode categorical string variables into numeric variables for subsequent analyses
* Set survival analysis parameters for stroke events
stset stroke_time_cox    , failure( stroke_status_cox    == 1)
* Mediation Analysis with PhenoAgeAccel as mediator
med4way digm_score   phenoageaccel     age    sex_number    ethnic_number    TDI   smoke_current   smoke_previous   alcohol_current   alcohol_previous   PA_number education_lower_secondary education_other education_upper_secondary living_alone_number     , a0(4) a1(6) m(-0.5223096) yreg(cox) mreg(linear) fulloutput


<p align="center">
<img src="materials/main_logo.JPG" alt="drawing"/>
</p>

# SQL-DataBase
Implementation of database with data about School 21 and writing procedures and functions to retrieve information, as well as procedures and triggers to change it.

## Logical view of database model
<p align="center">
<img src="materials/SQL2.png" alt="drawing" width="350"/>
</p>

Information about each table, relationship and constraints you can find in *materials* or by this [link](https://github.com/dpoliwhi/SQL-DataBase/blob/master/materials/tables_info.md "tables_info.md")

## Part 1. Creating a database

Written a *part1.sql* script that creates the database and all the tables described above.
Added procedures that allow to import and export data for each table from/to a file with a *.csv* extension. \
The *csv* file separator is specified as a parameter of each procedure.


To import data from .csv files (if you on MacOs) just run 
  ```
  sh Part1.sh
  ```
or uncomment rows in Part1.sql with procedure execution


There are at least 10 records in each table.

## Part 2. Changing data

##### 1) Written a procedure for adding P2P check
Parameters: nickname of the person being checked, checker's nickname, task name, P2P check status, time. \
If the status is "start", add a record in the Checks table (use today's date). \
Add a record in the P2P table. \
If the status is "start", specify the record just added as a check, otherwise specify the check with the latest (by time) unfinished P2P step.

##### 2) Written a procedure for adding checking by Verter
Parameters: nickname of the person being checked, task name, Verter check status, time. \
Add a record to the Verter table (as a check specify the check of the corresponding task with the latest (by time) successful P2P step)

##### 3) Written a trigger: after adding a record with the "start" status to the P2P table, change the corresponding record in the TransferredPoints table

##### 4) Written a trigger: before adding a record to the XP table, check if it is correct

### Part 3. Getting data

In this part created 25 different functions or procedures to get data from DataBase
All tasks you can find in *materials* or by this [link](https://github.com/dpoliwhi/SQL-DataBase/blob/master/materials/part3_tasks.md "part3_tasks.md")

## Bonus. Part 4. Metadata

For this part of the task, i created a separate database, in which i imlemented the tables, functions, procedures, and triggers needed to test the procedures.

##### 1) Created a stored procedure that, without destroying the database, destroys all those tables in the current database whose names begin with the phrase 'TableName'.

##### 2) Created a stored procedure with an output parameter that outputs a list of names and parameters of all scalar user's SQL functions in the current database. Do not output function names without parameters. The names and the list of parameters must be in one string. The output parameter returns the number of functions found.

##### 3) Created a stored procedure with output parameter, which destroys all SQL DDL triggers in the current database. The output parameter returns the number of destroyed triggers.

##### 4) Created a stored procedure with an input parameter that outputs names and descriptions of object types (only stored procedures and scalar functions) that have a string specified by the procedure parameter.

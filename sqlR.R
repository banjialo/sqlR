#############################################################
#       Purpose: Testing SQL Connection in R                #
#             Developed by: Banji Alo Team                  #
#                     Date: Sept 28, 2021                   #      
#############################################################


#check and require master package to be installed
if (!require("pacman")) install.packages("pacman")

#load main library
library (pacman)

#load other packages
p_load (tidyverse, RODBC)

#connect to data source
channel <- odbcConnect(dsn="NoCS", uid="", pwd="")

#run sample query
data <- sqlQuery(channel = channel, query = 
                   "
select top 10 * from dbo.DV_person

")

#check column names to be sure it is all good
names(data)

#close all connections
odbcCloseAll()
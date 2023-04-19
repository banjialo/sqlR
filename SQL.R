library(RSQLite )
library (dbplyr)

setwd ("C:/Users/Public/Database")

con <- dbConnect(RSQLite::SQLite(), ":memory:") #use an in-memory database
summary (con)

#create a database
conn <- dbConnect (RSQLite::SQLite(), "CarsDB.db") #connect to a database

#save the df as into the database
dbWriteTable (conn, "cars_data", mtcars)


#list the tables in the database
dbListTables (conn)



# Create toy data frames
car <- c('Camaro', 'California', 'Mustang', 'Explorer')
make <- c('Chevrolet','Ferrari','Ford','Ford')
df1 <- data.frame(car,make)
car <- c('Corolla', 'Lancer', 'Sportage', 'XE')
make <- c('Toyota','Mitsubishi','Kia','Jaguar')
df2 <- data.frame(car,make)

dfList <- list(df1,df2)


for(k in 1:length(dfList)){
  dbWriteTable(conn,"Cars_and_Makes", dfList[[k]], append = TRUE)
}

#running some SQL commands
dbGetQuery(conn, "SELECT * FROM Cars_and_Makes")
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")
dbGetQuery(conn,"SELECT car_names, hp, cyl FROM cars_data
                 WHERE cyl = 8")
dbGetQuery(conn,"SELECT car_names, hp, cyl FROM cars_data
                 WHERE car_names LIKE 'M%' AND cyl IN (6,8)")
dbGetQuery(conn,"SELECT cyl, AVG(hp) AS 'average_hp', AVG(mpg) AS 'average_mpg' FROM cars_data
                 GROUP BY cyl
                 ORDER BY average_hp")
avg_HpCyl <- dbGetQuery(conn,"SELECT cyl, AVG(hp) AS 'average_hp'FROM cars_data
                 GROUP BY cyl
                 ORDER BY average_hp")


## Lets assume that there is some user input that asks us to look only into cars that have over 18 miles per gallon (mpg)
# and more than 6 cylinders
mpg <-  18
cyl <- 6
Result <- dbGetQuery(conn, 'SELECT car_names, mpg, cyl FROM cars_data WHERE mpg >= ? AND cyl >= ?', params = c(mpg,cyl))
Result


# Visualize the table before deletion
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")
# Delete the column belonging to the Mazda RX4. You will see a 1 as the output.
dbExecute(conn, "DELETE FROM cars_data WHERE car_names = 'Mazda RX4'")
# Visualize the new table after deletion
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")


# Insert the data for the Mazda RX4. This will also ouput a 1
dbExecute(conn, "INSERT INTO cars_data VALUES (21.0,6,160.0,110,3.90,2.620,16.46,0,1,4,4,'Mazda RX4')")
# See that we re-introduced the Mazda RX4 succesfully at the end
dbGetQuery(conn, "SELECT * FROM cars_data")


#disconnect from the table

dbDisconnect(conn) #discnnect from a database



dbConnect (conn)


dbListTables(con) # list the tables in the database
dbGetQuery(con, "select * from ecom limit 10")


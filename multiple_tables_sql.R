#connect to database
channel <- odbcConnect(dsn = "NoCS", uid= "", pwd = "")


tableList <- c("[dbo].[A_Observation]","AtlasPublic")

# BUILD LIST OF DFS FROM QUERIES
dfList <- lapply (tableList, function(t) sqlQuery(channel, paste0("SELECT top 5 * FROM ",  t)))

dfList <- setNames(dfList, tableList)

list2env(dfList, envir=.GlobalEnv)



append_app <- function (x){
  paste0 ("'", x, "'", sep = "" )
}

mysheet %>% 
  select (firstname = `First Name`,
          middlename = `Middle Name`,
          lastname = `Last Name`,
          dob = `Date of Birth`,
          mobile = `Mobile Number`,
          street = `Address Number & Street`,
          suburb = Suburb) %>% 
  mutate (across (.cols = c(firstname, middlename, lastname),
                  ~ str_replace_all (., "'|\\(|\\)", "")),
          dob = strftime (dob, format = "%d/%m/%Y"),
          ID = row_number ()) %>% 
  mutate (across (.cols = everything(),
                  ~ append_app(.)),
          Values = glue ("({firstname}, {middlename}, {lastname}, {dob}, {mobile}, {street}, {suburb}, {ID})")) %>% 
  select (Values)


data %>%  count(MatchedType) %>%  adorn_totals("row")


data %>% 
  summarise (n_normal = sum(MatchedType == 1 & !is.na (MatchedType)),
             n_soundex = sum(MatchedType != 1 & !is.na (MatchedType)),
             n_total = sum(MatchedType & !is.na (MatchedType)),
             prop_soundex = paste0 (round (n_soundex/n_total * 100), "%")) %>% 
  pull (prop_soundex)


paste0(day(Sys.Date()), " ",months(Sys.Date())," ", year(Sys.Date() ), ", ", times(strftime(Sys.time(),"%H:%M:%S")))


data %>% 
  tabyl(MATCHED) %>% 
  rename (
    "NO OF ROWS" = n,
    PERCENTAGE = percent
  ) %>% 
  adorn_totals ("row") %>% 
  adorn_percentages("col",,,PERCENTAGE) %>% 
  adorn_pct_formatting(digits = 1)

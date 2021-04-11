#select works about the same as SQL
select(df, WhiteElo, BlackElo)

test <- mutate(df, white_range = case_when(
  WhiteElo < 1000 ~ "600-1000",
  WhiteElo >= 1000 & WhiteElo < 1500 ~ "1000-1500",
  WhiteElo >= 1500 & WhiteElo < 2000 ~ "1500-2000",
  WhiteElo >= 2000 & WhiteElo < 2500 ~ "2000-2500",
  WhiteElo >= 2500 & WhiteElo < 3000 ~ "2500-3000",
  WhiteElo >= 3000  ~ "3000+"
  
))

test <- mutate(test, black_range = case_when(
  BlackElo < 1000 ~ "600-1000",
  BlackElo >= 1000 & BlackElo < 1500 ~ "1000-1500",
  BlackElo >= 1500 & BlackElo < 2000 ~ "1500-2000",
  BlackElo >= 2000 & BlackElo < 2500 ~ "2000-2500",
  BlackElo >= 2500 & BlackElo < 3000 ~ "2500-3000",
  BlackElo >= 3000 ~ "3000+"
  
))

# This will get all the openings from games that adhere by the following
#   1. white's rating is between 600-1000
#   2. White won the game
#   3. The opening was played at least 100 times 
f <- as.data.frame(table(pull(filter(test, white_range == "600-1000" & Result == "1-0"), var="ECO")))
f <- filter(f, Freq >= 100)

f2 <- as.data.frame(table(pull(filter(test, black_range == "600-1000" & Result == "0-1"), var="ECO")))
f2

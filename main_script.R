#select works about the same as SQL
require(ggplot2)
require(dplyr)
require(plyr)


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
f <- dplyr::filter(f, Freq >= 100)

f2 <- as.data.frame(table(pull(filter(test, black_range == "600-1000" & Result == "0-1"), var="ECO")))


op <- dplyr::filter(test, white_range == "600-1000")
op <- select(op, result, ECO)

totalCounts <- count(test, vars=c("ECO", "white_range"))
names(totalCounts) <- c("ECO", "white_range", "totalFreq")

counts <- count(test, vars=c("white_range", "ECO", "Result"))
tc <- dplyr::inner_join(counts, totalCounts)


tc <- dplyr::filter(tc, Result != "*")

# Filter out openings with totals below certain amount of total games played
min_games <- 10
min_games_tc <- dplyr::filter(tc, totalFreq >= min_games & totalFreq <= 5000)

rating_tc <- dplyr::filter(min_games_tc, white_range == "1000-1500")

ggplot(data=rating_tc, aes(x=ECO, y=freq, fill=Result)) +
  geom_bar(stat="identity")


#get win rate in percentage
tc_with_freq <- mutate(rating_tc, win_percent = freq / totalFreq)

opening_range <- dplyr::filter(rating_tc, grepl("^B[2-9]", ECO))
ggplot(data=opening_range, aes(x=ECO, y=freq, fill=Result)) +
  geom_bar(stat="identity", position=position_dodge())


tc_with_freq <- dplyr::filter(tc_with_freq, tc_with_freq$Result == "1-0" & tc_with_freq$win_percent > 0.55)
tc_with_freq

ggplot(data=tc_with_freq, aes(x=ECO, y=win_percent)) +
  geom_bar(stat="identity")


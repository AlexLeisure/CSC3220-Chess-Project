#ggplot 2 stuff

#ggplot2 visualizations are composed of
# 1. Data
# 2. Layers
# 3. Scales
# 4. Coordinates
# 5. Faceting
# 6. Themes


# required ggplot2 components

# 1. Data 
# 2. Aesthetics - The mappings of your data to the visualization
#                 For example, mapping the value of Titanic passenger ages to the y axis
# 3. Layers - visualization. functions with "geom" will be this

library(ggplot2)

ggplot(df) + geom_density(aes(WhiteElo)) + geom_density(aes(BlackElo))

ggplot(filter(test, white_range == "1000-1500")) + geom_density(aes(WhiteElo))


ggplot(test, aes(x=ECO)) +
  geom_bar()

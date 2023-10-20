rawData <- "state year population
FL 2010 18511620
FL 2011 18688767
FL 2012 18885152
FL 2013 19091156
FL 2014 19361792
FL 2015 19645772
FL 2016 19934451"

flPopulation <- read.table(textConnection(rawData),header=TRUE)
theModel <- lm(population ~ year,data = flPopulation)
summary(theModel)

year <- 2017:2020
predictions <- (year * theModel$coef[2]) + theModel$coef[1]
data.frame(year,predictions)

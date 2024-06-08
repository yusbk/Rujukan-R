# https://www.r-bloggers.com/2016/06/how-to-use-r-for-matching-samples-propensity-score/
pacman::p_load(knitr, MatchIt, tableone)
library(MatchIt)
library(pak)
pak::pkg_install("ybkamaleri/wakefield@tib")
library(wakefield)

set.seed(1234)
df.patients <- wakefield::r_data_frame(n = 250,
                                       age(x = 30:78,
                                name = 'Age'),
                            sex(x = c("Male", "Female"),
                                prob = c(0.70, 0.30),
                                name = "Sex"))

df.patients$Sample <- as.factor('Patients')
summary(df.patients)

set.seed(1234)
df.population <- r_data_frame(n = 1000,
                              age(x = 18:80,
                                  name = 'Age'),
                              sex(x = c("Male", "Female"),
                                  prob = c(0.50, 0.50),
                                  name = "Sex"))
df.population$Sample <- as.factor('Population')
summary(df.population)

# Merge both
mydata <- rbind(df.patients, df.population)
mydata$Group <- as.logical(mydata$Sample == 'Patients')
mydata$Distress <- ifelse(mydata$Sex == 'Male', age(nrow(mydata), x = 0:42, name = 'Distress'),
                          age(nrow(mydata), x = 15:42, name = 'Distress'))

pacman::p_load(tableone)
table1 <- CreateTableOne(vars = c('Age', 'Sex', 'Distress'),
                         data = mydata,
                         factorVars = 'Sex',
                         strata = 'Sample')
table1 <- print(table1,
                printToggle = FALSE,
                noSpaces = TRUE)

kable(table1[,1:3],
      align = 'c',
      caption = 'Table 1: Comparison of unmatched samples')


set.seed(1234)
match.it <- matchit(Group ~ Age + Sex, data = mydata, method="nearest", ratio=1)
a <- summary(match.it)

plot(match.it, type = 'jitter', interactive = FALSE)

## Save matched data
df.match <- match.data(match.it)[1:ncol(mydata)]
rm(df.patients, df.population)

# Match 5
set.seed(1421)
match.it5 <- matchit(Group ~ Age + Sex, data = mydata, method="nearest", ratio=5)
a5 <- summary(match.it5)

plot(match.it5, type = 'jitter', interactive = FALSE)
## Save matched data
df.match5 <- match.data(match.it5)[1:ncol(mydata)]

# Match 5 and Distress
set.seed(1421)
match.it5d <- matchit(Group ~ Age + Sex + Distress,
                      data = mydata,
                      method="nearest",
                      ratio=5,
                      verbose = T)

a5d <- summary(match.it5d)

plot(match.it5d, type = 'jitter', interactive = FALSE)
## Save matched data
df.match5d <- match.data(match.it5d)[1:ncol(mydata)]
dt5d <- as.data.table(df.match5d)

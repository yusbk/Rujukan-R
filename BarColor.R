mt_mean <-   mtcars %>% group_by(cyl) %>% summarise(avg_mpg = mean(mpg) )

g <- ggplot( mt_mean , aes(x=factor(cyl), y =avg_mpg)) +
    geom_bar(stat = 'identity', aes(fill = avg_mpg > 25 )  )

g2 <- g + scale_fill_manual(values = c('red', 'black'), guide="none" )

##### Bar color

area <- c("Tawau", "Sandakan", "Semporna", "Kunak")
sale <- c(16.5, 13.5, 14, 13)
df.sale <- data.frame(area, sale)
colnames(df.sale) <- c("Penduduk", "Jumlah keseluruhan")

## opt 1
library(ggplot2)
library(gridExtra)
area.color <- c(NA, "withcolor", NA, NA)
plot.sale.bad1 <- ggplot(data=df.sale, aes(x=area, y=sale, fill=area.color)) +
  geom_bar(stat="identity") +
  xlab(colnames(df.sale)[1]) +
  ylab(colnames(df.sale)[2]) +
  ggtitle("Taburan penduduk")
plot.sale.bad1

## opt 2

plot.sale.bad2 <- ggplot(data=df.sale, aes(x=area, y=sale, fill=area)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("grey50", "red", "grey50", "grey50")) +
  xlab(colnames(df.sale)[1]) +
  ylab(colnames(df.sale)[2]) +
  ggtitle("Taburan penduduk")
plot.sale.bad2


#### Bar color 2
set.seed(34521)
RegData1 <- mtcars[sample(nrow(mtcars), 10),]
RegData <- dplyr::sample_n(mtcars, 10)

## Give column name
RegData1$navn <- rownames(RegData1)
RegData <- tibble::rownames_to_column(RegData, "navn")

ggplot(RegData, aes(navn, mpg)) + geom_bar(stat = 'identity') + coord_flip()
## reorder høyst på toppen
plot1 <- ggplot(RegData, aes(x=reorder(navn, mpg), y=mpg))
plot2 <- plot1 + geom_bar(stat = "identity", aes(fill = navn == 'Merc 280')) +
    # y = mpg + 1.3 for adjusting text position
    geom_text(aes(y = mpg + 1.3, label=paste0(mpg, '%'))) +
    scale_fill_manual(values = c('lightblue', 'darkblue'), guide = 'none') +
    scale_x_discrete(expand=c(0,0)) + #ingen border dvs begynner fra null
    scale_y_continuous(limits = c(0,30), expand=c(0,0)) + # samme
    coord_flip()

plot2
rn <- RegData[,c(1,3)]
grn <- tableGrob(rn, rows = NULL)
grn$widths = unit(rep(1/ncol(grn), ncol(grn)), "npc")

plot2 + annotation_custom(grn)

grid.table(rn)
tableGrob(rn)

##### Table and bar - Aligning
library(ggplot2)
library(gridExtra)
library(grid)
tg <- tableGrob(head(iris), rows=NULL, cols = NULL)
tg$widths <- unit(rep(1/ncol(tg),ncol(tg)),"npc")
tg$heights <- unit(rep(1/nrow(tg),nrow(tg)),"npc")

qplot(colnames(iris), geom="bar")+ theme_bw() +
    scale_x_discrete(expand=c(0,0)) +
    scale_y_continuous(lim=c(0,2), expand=c(0,0)) +
    annotation_custom(ymin=1, ymax=2, xmin=-Inf, xmax=Inf, tg)


#### Table and plot

library(grid)
library(gridExtra)
library(ggplot2)
xta=data.frame(f=rnorm(37,mean=400,sd=50))
xta$n=0
for(i in 1:37){xta$n[i]<-paste(sample(letters,4),collapse='')}
xta$c=0
for(i in 1:37){xta$c[i]<-sample((1:6),1)}
rect=data.frame(xmi=seq(0.5,36.5,1),xma=seq(1.5,37.5,1),ymi=0,yma=10)
xta=cbind(xta,rect)
a = ggplot(data=xta,aes(x=n,y=f,fill=c)) + geom_bar(stat='identity')+ theme(legend.position = "top")+xlab("")

none <- element_blank()
z=ggplot(xta, aes(x = n, y = "fvalues",
     label = round(f,1)) )+
     geom_text(size = 3)+ theme_bw()  +
     theme(panel.grid.major = none, legend.position = "none",
         panel.border = none, axis.text.x = none,
         axis.ticks = none) + theme(plot.margin = unit(c(-0.5,
                                                         1, 0, 0.5), "lines")) + xlab(NULL) + ylab(NULL)

Layout <- grid.layout(nrow = 2, ncol = 1, heights = unit(c(2,
     0.25), c("null", "null")))
grid.show.layout(Layout)
vplayout <- function(...) {
     grid.newpage()
     pushViewport(viewport(layout = Layout))
 }

subplot <- function(x, y) viewport(layout.pos.row = x,
     layout.pos.col = y)

mmplot <- function(a, b) {
     vplayout()
     print(a, vp = subplot(1, 1))
     print(b, vp = subplot(2, 1))
 }

mmplot(a, yz)




####

# Aligning labels and bars --------------------------------------------------
df <- data.frame(
  x = factor(c(1, 1, 2, 2)),
  y = c(1, 3, 2, 1),
  grp = c("a", "b", "a", "b")
)

# ggplot2 doesn't know you want to give the labels the same virtual width
# as the bars:
ggplot(data = df, aes(x, y, fill = grp, label = y)) +
  geom_bar(stat = "identity", position = "dodge") +
    geom_text(position = "dodge")

# So tell it:
ggplot(data = df, aes(x, y, fill = grp, label = y)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(position = position_dodge(0.9))

# Use you can't nudge and dodge text, so instead adjust the y postion
ggplot(data = df, aes(x, y, fill = grp, label = y)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(y = y + 0.05), position = position_dodge(0.9), vjust = 0)


# To place text in the middle of each bar in a stacked barplot, you
# need to do the computation yourself
df <- transform(df, mid_y = ave(df$y, df$x, FUN = function(val) cumsum(val) - (0.5 * val)))

ggplot(data = df, aes(x, y, fill = grp, label = y)) +
 geom_bar(stat = "identity") +
 geom_text(aes(y = mid_y))

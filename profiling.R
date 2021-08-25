## Use aprof package
## http://marcodvisser.github.io/aprof/Quickstart/
remotes::install_github("MarcoDVisser/aprof")

# create function to profile
     foo <- function(N){
             preallocate<-numeric(N)
             grow<-NULL
              for(i in 1:N){
                  preallocate[i]<-N/(i+1)
                  grow<-c(grow,N/(i+1))
                 }
     }

require(aprof)

#Aprof requires a source file to associate with profiler output
#save function to a source file and reload
dump("foo",file="foo.R")
source("foo.R")

#Run profiler
#create file to save profiler output
tmp<-tempfile()

#Profile the function
Rprof(tmp,line.profiling=TRUE)
foo(5e4)
Rprof(append=FALSE)

#Create a aprof object
fooaprof<-aprof("foo.R",tmp)
#get basic info
fooaprof
#projection of potential code optimization gains
summary(fooaprof)

plot(fooaprof) #for shorter codes
profileplot(fooaprof) #for longer codes

#When single line is the bottleneck but it consists of
#lots of nested functions. Here it's line no. 7 in the fooaprof codes
targetedSummary(fooaprof, target = 7, findParent = TRUE)


## Memory statistics
## Profile the function
Rprof(tmp,line.profiling=TRUE,memory.profiling=TRUE)
foo(5e4)
Rprof(append=FALSE)

## Create a aprof object
fooaprof<-aprof("foo.R",tmp)
plot(fooaprof)

fooaprof

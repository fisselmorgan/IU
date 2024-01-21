# We consider Fisher's famous iris data set and visualize data both as scatterplot and pairs plot
# In classification we try predict the "label" or "class" of an observation from the variables we measure.


data(iris);  	    # include the famous iris data
n = nrow(iris);     # n is number of observations (will usually use "n" for this)
type = rep(0,n);
color = rep(0,n);

type[iris[,5] == "setosa"] = "s";      # class is 5th column.  
type[iris[,5] == "versicolor"] = "c";
type[iris[,5] == "virginica"] = "v";

color[iris[,5] == "setosa"] = 1;
color[iris[,5] == "versicolor"] = 2;
color[iris[,5] == "virginica"] = 3;


# type is now a vector of "s" or "c" or "v" for 3 types


#   here is a scatterplot

plot(iris[,1],iris[,2],pch=type)  # scatterplot
plot(iris[,3],iris[,2],pch=type,col=color)  # scatterplot


# alternaltively could use
# plot(iris[,"Sepal.Length"],iris[,"Sepal.Width"],pch=type)

# here is pairs plot


pairs(iris[,1:4],pch=type,col=color,cex=2)   # pairs plot using all four variables

<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org9c7a8e9">1. ggplot2</a>
<ul>
<li><a href="#orgabf0151">1.1. Label</a></li>
</ul>
</li>
</ul>
</div>
</div>

# ggplot2<a id="org9c7a8e9"></a>

Pelbagai rujukan berkaitan dengan `ggplot2`

## Label<a id="orgabf0151"></a>

Untuk tukarkan warna guna `color` (elakkan `fill`) di aesthetic kemudian tetapkan
warna dengan `scale_color_manual`

    myColors <- c("#56ddc5", "#ff3db7", "#4699dd")
    ggplot(mtcars, aes(x=mpg, y=hp, col=as.factor(cyl))) +
      geom_point() +
      scale_color_manual(values=myColors)
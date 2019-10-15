## hexsticker for rapporteket
install.packages("hexSticker")
install.packages("remotes")

remotes::install_github("GuangchuangYu/hexSticker")
library(hexSticker)

imgurl <- system.file("figures/cat.png", package="hexSticker")
sticker(imgurl, package="hexSticker", p_size=20, s_x=1, s_y=.75, s_width=.6,
        filename="inst/figures/imgfile.png")

rapimg <- "./images/raplogo.svg"
sticker(rapimg, package = "Rapporteket", p_size = 13, s_x = 1, s_y = .75,
  h_fill="#EDF1FF", h_color="#003278", p_color = "black", filename = "images/raphex.png", p_family = "Aller_Bd")

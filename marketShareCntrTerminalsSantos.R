##############################################################################################

# Objetive: Create animation with the market share of the container terminals
#           in the port of Santos in the last ten years

# Data set available on 

#https://www.portodesantos.com.br/informacoes-operacionais/estatisticas/mensario-estatistico/

# Developed by Gigio Gomes, https://github.com/gigiogomes on August 2022.

##############################################################################################

# importing libraries

library(ggplot2)
library(gganimate)
library(gifski)
library(tidyverse)
library(zoo)
library(lubridate)
library(dplyr)
library(readxl)
library(scales)
library(ggimage)
library(ggthemes)

# importing data

df <- read_excel("port_of_santos.xlsx", sheet ="raw")

head(df)

# importing logos

logos <- data.frame(player = c("Brasil Terminal","DP World Santos", "Ecoporto Santos", "Santos Brasil", "Libra", "Rodrimar"), 
                    logo = c("btp.png", "dpw.png", "ecoporto.png", "sbs.png", "libra.png", "rodrimar.png"))

# Calculating teu's and uniting year and monthe column

df2 <- df %>% 
  mutate(teus = ifelse(size == 20, qtty, ifelse(size == 40, qtty * 2, 0))) %>% 
  unite("yearMonth", c("year", "month"), sep = "-")

head(df2)

# transforming year-month column into date format

df2$AnoMes <- lubridate::ym(df2$yearMonth)

head(df2)

# summarizing teu's, calculating market share and grouping by month and player

df3 <- df2 %>% 
  group_by(AnoMes, player) %>% 
  summarise(totalTeus = sum(teus)) %>% 
  mutate(marketShare = totalTeus / sum(totalTeus))

head(df3)

# merging data with logos

df4 <- merge(df3, logos, by = "player")

head(df4)

# plotting

myPlot <- ggplot(df4, aes(totalTeus, marketShare)) +
  geom_image(aes(image = logo), size = 0.1) +
  scale_size(range = c(2, 12)) +
  theme_bw(base_size = 16) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(title = "Market share of the main container terminals in Santos in the last ten years",
       subtitle = "Month: {format(frame_time, '%Y-%m')}", caption = "Source: Santos Port Authority",
       x = "Total Teus", y = "Market Share") +
  transition_time(df4$AnoMes) + 
  ease_aes("linear")

myPlot

# rendering and saving animation

animate(myPlot, duration = 60, fps = 40, width = 800, height = 800, renderer = gifski_renderer())
anim_save("animation.gif")



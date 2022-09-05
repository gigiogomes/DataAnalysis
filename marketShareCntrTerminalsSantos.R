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

df <- read_excel("port_of_santos.xlsx", sheet ="raw")

logos <- data.frame(player = c("Brasil Terminal","DP World Santos", "Ecoporto Santos", "Santos Brasil", "Libra", "Rodrimar"), 
                    logo = c("btp.png", "dpw.png", "ecoporto.png", "sbs.png", "libra.png", "rodrimar.png"))

head(df)

df2 <- df %>% 
  mutate(teus = ifelse(size == 20, qtty, ifelse(size == 40, qtty * 2, 0))) %>% 
  unite("yearMonth", c("year", "month"), sep = "-")

head(df2)

df2$AnoMes <- lubridate::ym(df2$yearMonth)

head(df2)

df3 <- df2 %>% 
  group_by(AnoMes, player) %>% 
  summarise(totalTeus = sum(teus)) %>% 
  mutate(marketShare = totalTeus / sum(totalTeus))

head(df3)

df4 <- merge(df3, logos, by = "player")

head(df4)

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

animate(myPlot, duration = 60, fps = 40, width = 800, height = 800, renderer = gifski_renderer())
anim_save("Animacao.gif")

myPlot

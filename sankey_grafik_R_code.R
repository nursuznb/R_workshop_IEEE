library(readr)
library(readxl)
library(dplyr)
library(highcharter)

kat <- read_excel(
  file.choose(),col_names = FALSE
)

head(kat)

colnames(kat) <- c("Bolum", "Sinif")

edges <- kat %>%
  count(.data$Bolum, .data$Sinif, name = "n") %>%
  rename(from = Bolum,
         to   = Sinif,
         weight = n) 

hc <- hchart(
  edges,
  "sankey",
  hcaes(from = from, to = to, weight = weight)
) %>% 
  hc_title(
    text = "Kat\u0131l\u0131mc\u0131lar\u0131n B\u00f6l\u00fcm ve S\u0131n\u0131fa G\u00f6re Da\u011f\u0131l\u0131m\u0131",
    style = list(fontFamily = "Arial", fontSize = "22px")
  ) %>%
  hc_tooltip(
    # tooltip yazısı 
    pointFormat = paste(
      "<b>{point.fromNode.name}</b> → <b>{point.toNode.name}</b><br/>",
      "Katılımcı sayısı: <b>{point.weight}</b>"
    )
  ) %>%
  hc_chart(height = 800) %>%   # daha uzun tuval
  hc_plotOptions(
    sankey = list(
      dataLabels = list(
        enabled = TRUE,
        allowOverlap = TRUE, # çakışsa bile gizlemesin
        style = list(fontSize = "11px"),
        color = "white"
      ),
      nodePadding = 8 # düğümler arası boşluk
    )
  )%>% 
  hc_exporting(enabled = TRUE) %>%      # PNG / SVG / pdf vs. export tuşu
  hc_add_theme(hc_theme_flat())       

hc

htmlwidgets::saveWidget(hc, "sankey_interaktif.html", selfcontained = TRUE)




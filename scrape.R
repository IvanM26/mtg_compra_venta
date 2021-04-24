library(tidyverse)
library(readxl)
library(rvest)
library(textclean)
library(writexl)

datos <- read_xlsx("datos.xlsx")

n_listas <- nrow(datos)

listado_cartas_vendedor <- vector("list", n_listas)

for (i in 1:n_listas){
  
  vendedor_i <- datos$Vendedor[[i]]
  contacto_i <- datos$Contacto[[i]]
  link_i <- paste0(datos$LINK_SCRYFALL[[i]], "?as=list&with=usd")
  
  cartas_vendedor_i <- read_html(link_i) %>% 
    html_nodes(".deck-list-entry-name a") %>% 
    html_text() %>% 
    tibble(
      CARTA = .,
      VENDEDOR = vendedor_i,
      CONTACTO = contacto_i
    ) %>% 
    mutate(
      CARTA = replace_non_ascii(CARTA, "") %>% 
        str_trim(side = "both")
    )
  
  listado_cartas_vendedor[[i]] <- cartas_vendedor_i
}

tabla <- bind_rows(listado_cartas_vendedor)

write_xlsx(tabla, "lista_cartas_procesada.xlsx")

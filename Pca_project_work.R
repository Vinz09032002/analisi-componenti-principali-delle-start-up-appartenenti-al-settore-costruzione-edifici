

# installazione pacchetti:
install.packages("Rcmdr")
library(Rcmdr)
install.packages("RcmdrPlugin.FactoMineR")
library(RcmdrPlugin.FactoMineR)
install.packages("FactoMineR")
library(FactoMineR)
install.packages("openxlsx")
library(openxlsx)
install.packages("psych")
library(psych)
install.packages("tidyverse")
library(tidyverse)
install.packages("readxl")
library(readxl)
install.packages("openxls")
library(openxlsx)
install.packages("corrplot")
library(corrplot)
install.packages("dplyr")
library(dplyr)
install.packages("writexl")
library(writexl)

# analisi della correlazione tra i dati:
dts <-  read_xls("~/Project work/dati/indici_datasetPronto.xls", sheet = "RisultatiAnalisi")
dts <- as_tibble(dts)
dts <- dts %>% 
  select(-RS,-ID, - ANNO)
corrplot(cor(dts)) # presente una struttura di correlazione tra le variabili

# codice prodotto dall'analisi PCA tramite il pacchetto FactoMineR e l'utilizzo dell'R commander #

# scaricare il dataset e operazioni preliminari:
Dataset <- 
  readXL("~/Project work/dati/indici_datasetPronto.xls",
         rownames=FALSE, header=TRUE, na="", sheet="RisultatiAnalisi", 
         stringsAsFactors=TRUE)

row.names(Dataset) <- as.character(Dataset$ID)

Dataset$ID <- NULL
Dataset.PCA<-Dataset[, c("RI", "INDICE_DI_LIQUIDITA", "EBIDTA.Vendite", 
                         "ROS", "ROA", "Indice.di.copertura.delle.immob...")]
# pca:
pca <-PCA(Dataset.PCA , scale.unit=TRUE, ncp=5, graph = FALSE)

# mappa fattoriale delle unità:
print(plot.PCA(pca, axes=c(1, 2), choix="ind", habillage="none", 
               col.ind="black", col.ind.sup="blue", col.quali="magenta", label=c("ind", "ind.sup", "quali"),new.plot=TRUE))

# mappa fattoriale delle variabili:
print(plot.PCA(pca, axes=c(1, 2), choix="var", new.plot=TRUE, 
               col.var="black", col.quanti.sup="blue", label=c("var", "quanti.sup"), 
               lim.cos2.var=0))
summary(pca, nb.dec = 3, nbelements=10, nbind = 10, ncp = 3, file="")
pca$eig
pca$var$cor

# osserviamo i valori di correlazione tra le variabili e le 2 cp scelte:
cor_cp <- tibble(Dim1 = pca$var$cor[,1],
                 Dim2 = pca$var$cor[,2],
                 Indici = c("RI","Indice_liquidità","EBIDTA/Vendite",	"ROS","ROA",	"Indice_copertura_immob"))
cor_cp <- cor_cp %>% 
  column_to_rownames("Indici")
write.xlsx(cor_cp, file = "Correlazione_cp.xlsx")


# rotazione:
rotazione <- principal(Dataset.PCA, nfactors  = 2, rotate = "varimax", score = T)
rotazione
rotazione$loadings
cor_rc <- tibble(dim1 = rotazione$loadings[,1],
                 dim2 = rotazione$loadings[,2],
                 Indici = c("RI","Indice_liquidità","EBIDTA/Vendite",	"ROS","ROA",	"Indice_copertura_immob"))
cor_rc <- cor_rc %>% 
  column_to_rownames("Indici")
write.xlsx(cor_rc, file = "CorrelazioniRuotate.xlsx")


###### validazione scelta numero componenti principali:
n <- length(dts$INDICE_DI_LIQUIDITA)
x <- NULL
for (i in 1:1000) {
  a2<-rnorm(n)
  a3<-rnorm(n)
  a4<-rnorm(n)
  a5<-rnorm(n)
  dts_confront = data.frame(a2,a3,a4,a5)
  pca_dts_confronto <-PCA(dts_confront, graph=F, ncp = 3)
  pca_dts_confronto$eig

} 
pca_dts_confronto$eig # in linea con la variabilità spiegata dai nostri dati
######

# estrapolazione su file excell degli scores ottenuti per i 3 anni (conclusioni su excell):
scores <- tibble(score_RC1 = rotazione$scores[,1],
                 scores_RC2 = rotazione$scores[,2])

scores <- scores %>% 
  mutate(Anno = Dataset$ANNO) 
write.xlsx(scores, file = "FileFinale.xlsx")

# mappa fattoriale degli scores nei 3 anni:

RS <-  read_xls("dati/indici_datasetPronto.xls", sheet = "RisultatiAnalisi")
RS <- as_tibble(RS)
RS <- RS %>% 
  select(RS)

Anno_fc <- as.factor(scores$Anno)
id_series <- rep(1:24, times = 3)


scores <- scores %>% 
  select(-Anno) %>% 
  mutate(Anno = Anno_fc,
         Ragione_sociale = RS,
         id = id_series) 


scores %>% 
  ggplot(aes(x = score_RC1, y = scores_RC2, color = Anno, label = id))+
  geom_point(size = 2)+
  scale_color_manual(values = c("2017" = "black", "2018" = "blue", "2019" = "red"))+
  geom_hline(yintercept = 0, linetype = "dashed", color = "black")+
  geom_vline(xintercept = 0, linetype = "dashed", color = "black")+
  labs(title = "Varizione di Scores nei 3 anni", x = "RC1", y = "RC2")+
  geom_text(vjust = 2, size = 3)











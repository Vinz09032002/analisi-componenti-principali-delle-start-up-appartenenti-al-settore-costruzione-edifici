# Analisi delle componenti principali su start-up

## Obiettivo
Individuare i principali fattori finanziari che influenzano la performance delle start-up nel periodo 2016–2018 e scegliere le aziende che hanno avuto un buon miglioramento e sulle quali si sarebbe potuto investire.

## Dati
- Il campionamento delle aziende é stato tratto da https://startup.registroimprese.it/isin/home
- Importazione del dataset su excel per individuare le aziende (s.r.l. e s.p.a.) iscritte al registro delle start-up  (anno 2016)
- Inserimento dei codici fiscali su Aida per la selezione degli indici.

## Metodologia
- Standardizzazione delle variabili
- Applicazione PCA
- Analisi varianza spiegata
- Interpretazione delle componenti

## Risultati
- La prima componente rappresenta ...
- La seconda componente rappresenta ...
- Identificazione di start-up con maggiore potenziale: sono quelle individuate di rosso, facenti parte del primo quadrante in alto a destra. Perció le start up in cui proponiamo di investire
  sono: GEODATALAB S.R.L.S. - SMART HUB S.R.L. - SET IT SRL - BIOMEDICAL SAFETY SRL
- Le peggiori aziende che sconsigliamo di investire sono situate nel quadrante in basso a sinistra, come ad esempio le start up KOPEN S.R.L. - SMART HUB S.R.L. 

## Strumenti
- R
- librerie: (Rcmdr, RcmdrPlugin.FactoMineR, FactoMineR, openxlsx, psych, tidyverse, readxl, corrplot, dplyr, writexl)


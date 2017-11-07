library(httr)
library(XML)
library(xlsx)
library(rvest)
library(data.table)
library(plyr)

baseurl <-c("http://hidroweb.ana.gov.br/Estacao.asp?Codigo=", "&CriaArq=true&TipoArq=1")

library(openxlsx)
dadosEstacoes <- read.xlsx("Estacao.xlsx", sheet = 1, colNames = FALSE, cols=c(10,18,19,21,22))
colnames(dadosEstacoes) <- c("Municipio", "Estacao", "lat", "long")

k <- 0
estacaoCHUVAS <- data.frame()
estacaoVAZOES <- data.frame()

for (est in c(538069,21850000,64247000)){
  k <- k + 1
  print(k)
  estacaoChuva <- as.character(html_text(html_node(read_html(paste0(baseurl[1], est, baseurl[2])),paste0('form'))))
  estacaoChuva <- strsplit(estacaoChuva, split = " ")
  if ("Chuvas" %in% estacaoChuva[[1]]) {
    setwd("/Users/julianadaikawa/Desktop/IC/CHUVAS")
    r <- POST(url = paste0(baseurl[1], est, baseurl[2]), body = list(cboTipoReg = "10"), encode = "form")
    if (r$status_code == 200) {
      cont <- content(r, as = "text", encoding = "ISO-8859-1")
      arquivo <- unlist(regmatches(cont, gregexpr("ARQ.+/CHUVAS.ZIP", cont)))
      arq.url <- paste0("http://hidroweb.ana.gov.br/", arquivo)
      download.file(arq.url, paste0(est, ".zip"), mode = "wb")
      cat("Arquivo", est, "salvo com sucesso.\n")
      unzip(paste0(est,".zip"))
      estacaoCHUVAS <- rbind.fill(estacaoCHUVAS,fread("CHUVAS.TXT", skip="//"))
      }
    }
  if (sum(grepl("Vaz", estacaoChuva[[1]]))>0) {
    setwd("/Users/julianadaikawa/Desktop/IC/VAZOES")
    r <- POST(url = paste0(baseurl[1], est, baseurl[2]), body = list(cboTipoReg = "9"), encode = "form")
    if (r$status_code == 200) {
      cont <- content(r, as = "text", encoding = "ISO-8859-1")
      arquivo <- unlist(regmatches(cont, gregexpr("ARQ.+/VAZOES.ZIP", cont)))
      arq.url <- paste0("http://hidroweb.ana.gov.br/", arquivo)
      download.file(arq.url, paste0(est, ".zip"), mode = "wb")
      cat("Arquivo", est, "salvo com sucesso.\n")
      unzip(paste0(est,".zip"))
      estacaoVAZOES <- rbind.fill(estacaoVAZOES,fread("VAZOES.TXT", skip="//"))
      }
    }
}


teste <- "VAZOES.TXT"
teste2 <- readChar(teste, file.info(teste)$size)
strsplit(teste2, "//")
csv <- textConnection(strsplit(teste2, "//")[[1]][17])
read.csv(csv)
read.csv(text=strsplit(teste2, "//")[[1]][17])




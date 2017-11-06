library(httr)
library(XML)
library(xlsx)
library(rvest)

baseurl <-c("http://hidroweb.ana.gov.br/Estacao.asp?Codigo=", "&CriaArq=true&TipoArq=1")

library(openxlsx)
dadosEstacoes <- read.xlsx("Estacao.xlsx", sheet = 1, colNames = FALSE, cols=c(10,18,19,21,22))
colnames(dadosEstacoes) <- c("Municipio", "Estacao", "lat", "long")

k <- 0

for (est in c(538069,21850000)){
  k <- k + 1
  print(k)
  estacaoChuva <- as.character(html_text(html_node(read_html(paste0(baseurl[1], est, baseurl[2])),paste0('form'))))
  estacaoChuva <- strsplit(estacaoChuva, split = " ")
  if ("Chuvas" %in% estacaoChuva[[1]]) {
    r <- POST(url = paste0(baseurl[1], est, baseurl[2]), body = list(cboTipoReg = "10"), encode = "form")
    if (r$status_code == 200) {
      cont <- content(r, as = "text", encoding = "ISO-8859-1")
      arquivo <- unlist(regmatches(cont, gregexpr("ARQ.+/CHUVAS.ZIP", cont)))
      arq.url <- paste0("http://hidroweb.ana.gov.br/", arquivo)
      download.file(arq.url, paste0(est, ".zip"), mode = "wb")
      cat("Arquivo", est, "salvo com sucesso.\n")}}
  if (sum(grepl("Vazões", estacaoChuva[[1]]))>0) {
    r <- POST(url = paste0(baseurl[1], est, baseurl[2]), body = list(cboTipoReg = "9"), encode = "form")
    if (r$status_code == 200) {
      cont <- content(r, as = "text", encoding = "ISO-8859-1")
      arquivo <- unlist(regmatches(cont, gregexpr("ARQ.+/VAZOES.ZIP", cont)))
      arq.url <- paste0("http://hidroweb.ana.gov.br/", arquivo)
      download.file(arq.url, paste0(est, ".zip"), mode = "wb")
      cat("Arquivo", est, "salvo com sucesso.\n")}
  
    } else {
      cat("Erro no arquivo", est, "\n")
    }
}





estacaoChuva <- as.character(html_text(html_node(read_html(paste0(baseurl[1], est, baseurl[2])),paste0('form'))))
estacaoChuva <- strsplit(estacaoChuva, split = " ")
if ("Chuvas" %in% estacaoChuva[[1]]) {
  r <- POST(url = paste0(baseurl[1], est, baseurl[2]), body = list(cboTipoReg = "10"), encode = "form")
  if (r$status_code == 200) {
    cont <- content(r, as = "text", encoding = "ISO-8859-1")
    arquivo <- unlist(regmatches(cont, gregexpr("ARQ.+/CHUVAS.ZIP", cont)))
    arq.url <- paste0("http://hidroweb.ana.gov.br/", arquivo)
    download.file(arq.url, paste0(est, ".zip"), mode = "wb")
    cat("Arquivo", est, "salvo com sucesso.\n")}}
if (sum(grepl("Vazões", estacaoChuva[[1]]))>0) {
  r <- POST(url = paste0(baseurl[1], est, baseurl[2]), body = list(cboTipoReg = "9"), encode = "form")
  if (r$status_code == 200) {
    cont <- content(r, as = "text", encoding = "ISO-8859-1")
    arquivo <- unlist(regmatches(cont, gregexpr("ARQ.+/VAZOES.ZIP", cont)))
    arq.url <- paste0("http://hidroweb.ana.gov.br/", arquivo)
    download.file(arq.url, paste0(est, ".zip"), mode = "wb")
    cat("Arquivo", est, "salvo com sucesso.\n")}
}






sum(grepl("Vazões", estacaoChuva[[1]]))
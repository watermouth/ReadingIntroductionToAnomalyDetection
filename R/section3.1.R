#' \code{compare_FX_price_diff_anomaly}
compare_FX_price_diff_anomaly <- function(start_date, end_date){
  library(quantmod)
  getFX(Currencies = "USD/JPY", from = as.Date(start_date), to = as.Date(end_date))
  plot(USDJPY)
  x2 <- as.numeric(USDJPY)
  x2 <- diff(x2)
  x2 <- (x2 - mean(x2)) / sd(x2)
  count <- length(x2)
  x1 <- rnorm(n = count, mean = 0, sd = 1)
  a1 <- (x1 - mean(x1)) ^ 2 / mean((x1-mean(x1))^2)
  a2 <- (x2 - mean(x2)) ^ 2 / mean((x2-mean(x2))^2)
  th <- qchisq(p=0.99, df=1)
  list(price=USDJPY, count=count, th=th, a1=a1, a2=a2)
}

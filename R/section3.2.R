#' 訓練データに異常標本が含まれている場合

rm(list=ls())

#' 1次元混合正規分布のEM法
#' 
#' $K$成分混合正規分布モデル
#' 
#' \[p(x) = \sum_{i=1}^{K} \pi_{i} N(x|\mu_i,\sigma_i^2) \]
#' 
#' parameter $\{ \pi_i, \mu_i, \sigma_i^2 \}_{i=1,...,K}$ を求める手順
#' 
#' 1) $\{ \pi_i, \mu_i, \sigma_i^2 \}$の初期値を適当に与える。
#' 
#' 2) データ$x^{(n)}$のi番目の正規分布への帰属度$q_i^{(n)}$を求める。
#' 
#' \[\displaystyle q_i^{(n)} = \frac{\pi_{i} N(x^{(n)}|\mu_i,\sigma_i^2)}{\sum_{i=1}^{K} \pi_{i} N(x^{(n)}|\mu_i,\sigma_i^2)}\]
#'
#' 3) $\{q_i^{(n)}\}_{i=1}^K$ から
#' \par 
#' $\displaystyle \mu_i = \frac{\sum_{n=1}^N q_i^{(n)} x^{(n)}}{\sum_{n=1}^N q_i^{(n)}}$,
#' $\displaystyle \sigma_i ^2 = \frac{\sum_{n=1}^N q_i^{(n)} \left(x^{(n)}-\mu_i\right)^2}{\sum_{n=1}^N q_i^{(n)}}$,
#' $\displaystyle \pi_i = \frac{1}{N}\sum_{n=1}^{N} q_i^{(n)}$
#' 
#' 4) 値が収束していなければ2)に戻る.
#'

#' ### 動作確認用データ
#' 
#' 信号成分
mu0 <- 3; sig0 <- 0.5
#' 
#' 雑音成分
mu1 <- 0; sig1 <- 3
#' 割合
pi0 <- 0.6; pi1 <- 0.4

solutions <- list(pi=c(pi0,pi1), mu=c(mu0, mu1), sigma=c(sig0, sig1))

N <- 1000
attr <- sample(0:1,N,replace=T,prob=c(pi0,pi1))
x <- vector(mode = "numeric", length = N)
x[which(attr == 0)] <- rnorm(sum(attr == 0), mean = mu0, sd = sig0)
x[which(attr == 1)] <- rnorm(sum(attr == 1), mean = mu1, sd = sig1)
x0 <- x[which(attr == 0)]
x1 <- x[which(attr == 1)]

hist(x, breaks=100)

#' EM法
#' 初期値
pi0 <- 0.5; pi1 <- 0.5
mu0 <- -5; mu1 <- 5
sig0 <- 2; sig1 <- 2

iterLength <- 20
mu_iter <- matrix(nrow = iterLength, ncol = 2)
sigma_iter <- matrix(nrow = iterLength, ncol = 2)
pi_iter <- matrix(nrow = iterLength, ncol = 2)
for (iter in 1:iterLength){
  #　帰属度の計算
  cprob0 <- dnorm(x = x, mean = mu0, sd = sig0)
  cprob1 <- dnorm(x = x, mean = mu1, sd = sig1)
  denom <-  (pi0 * cprob0 + pi1 * cprob1)
  q0 <- pi0 * cprob0 / denom
  q1 <- pi1 * cprob1 / denom
  # パラメータ更新
  pi0 <- mean(q0)
  pi1 <- mean(q1)
  mu0 <- sum(q0 * x) / (N*pi0)
  mu1 <- sum(q1 * x) / (N*pi1)
  sig0 <- sqrt(sum(q0 * (x - mu0)^2) / (N*pi0))
  sig1 <- sqrt(sum(q1 * (x - mu1)^2) / (N*pi1))
  pi_iter[iter,] <- c(pi0, pi1)
  mu_iter[iter,] <- c(mu0,mu1)
  sigma_iter[iter,] <- c(sig0, sig1)
}

#' 逐次更新による求解の様子
targets <- list(pi_iter, mu_iter, sigma_iter)
target.names <- names(solutions)
for (i in seq(1,length(targets))){
  target <- targets[[i]]
  matplot(x = 1:iterLength, target, pch = c("0","1")
          , xlab = "iter", ylab = target.names[i])
  for (j in seq(1,length(solutions[[i]]))){
    abline(h = solutions[[i]][j], xlab = NULL, ylab = NULL)
  }
}



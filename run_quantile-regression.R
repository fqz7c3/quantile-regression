library(dplyr)
library(quantreg)
library(rstan)
library(shinystan)

system.time(model <- stan_model(file="quantile-regression.stan",verbose=F))

standata <- list(N=150,P=3,Tau=0.1,Lambda=0, #Lambda parameter has not been tested yet
                 X=iris[,1:3] %>% as.matrix(ncol=2),Y=iris[,4] %>% unlist)
staninit <- function(){
  list(alpha=0,beta=rep(0,3))
}

system.time(stanres <- sampling(model,
                                data=standata,
                                init=staninit,
                                chains=3,
                                warmup=1000,
                                iter=3000,
                                thin=1,
                                seed=1))

stanres %>% print(pars=c("alpha","beta"),digits=4)

launch_shinystan(stanres)

#comparision with result of quantreg
qregres <- rq(Petal.Width~.,data=iris %>% select(-Species),tau=0.1)
qregres



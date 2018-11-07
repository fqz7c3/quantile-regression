data{
  int<lower=1> N;
  int<lower=1> P;
  real<lower=0,upper=1>Tau;
  real<lower=0> Lambda;
  vector<lower=-1e10,upper=1e10>[P] X[N];
  real Y[N];
}

parameters{
  real<lower=-1e10,upper=1e10> alpha;
  vector<lower=-1e10,upper=1e10>[P] beta;
}

transformed parameters{
  real resid[N];
  for(i in 1:N){
    resid[i]=Y[i]-alpha-dot_product(X[i],beta);
  }
}
model{
  for(i in 1:N){
    if(resid[i]>0){
      target+=-1*(Tau*resid[i]+Lambda*dot_self(beta));
    }else{
      target+=-1*((Tau-1)*resid[i]+Lambda*dot_self(beta));
    }
  }
}

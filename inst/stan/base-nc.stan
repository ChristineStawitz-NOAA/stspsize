data {
  int<lower=0> Nages;
  int<lower=0> Nyears;
  matrix[Nages, Nyears] laa;
}
parameters {
  real beta;
  matrix[Nages,Nyears] xaa_raw;
  real<lower=0> sigma_p;
  real<lower=0> sigma_o;
}
transformed parameters {
  matrix[Nages,Nyears] xaa;
  xaa[1, 1] = sigma_p;  // non-centered parameterization
  for (i in 2:Nages) {
    for(y in 2:Nyears){
      xaa[i, y] =  beta * xaa_raw[i - 1, y - 1] * sigma_p;  // non-centered parameterization
    }
  }
}
model {
  // non-centered parameterization:
  to_vector(xaa_raw) ~ std_normal();

  // observation model:
  to_vector(laa) ~ normal(to_vector(xaa), sigma_o);

  // priors:
  sigma_o ~ student_t(7, 0, 2);
  sigma_p ~ student_t(7, 0, 2);
  beta ~ normal(0, 3);
}

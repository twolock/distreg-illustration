sinhasinh <- custom_family(
  "sinhasinh", dpars = c("mu", "sigma", "eps", "delta"),
  links = c("identity", "log", "identity", "log"),
  lb = c(NA, NA, NA, NA),
  type = "real"
)
log_lik_sinhasinh <- function(i, draws) {
  mu <- draws$dpars$mu[, i]
  sigma <- draws$dpars$sigma[, i]
  eps <- draws$dpars$eps[, i]
  delta <- draws$dpars$delta[, i]
  y <- draws$data$Y[i]
  sinhasinh_lpdf(y, mu, sigma, eps, delta)
}
predict_sinhasinh <- function(i, draws, ...) {
  mu <- draws$dpars$mu[, i]
  sigma <- draws$dpars$sigma[, i]
  eps <- draws$dpars$eps[, i]
  delta <- draws$dpars$delta[, i]
  sinhasinh_rng(mu, sigma, eps, delta)
}

stan_funs <- "
  real sinhasinh_lpdf(real y, real mu, real sigma, real eps, real delta) {
    real y_z;
    real sigma_star;
    real S_y;
    real S_y_2;
    real C_y;
    real nll;
    
    nll = 0;
    sigma_star = sigma * delta;
    y_z = (y - mu)/sigma_star;
    
    S_y = sinh(eps + delta * asinh(y_z));
    S_y_2 = S_y * S_y;
    C_y = sqrt(1 + S_y_2);
    nll += -0.5 * S_y_2 - log(sigma_star);
    nll += log(delta) + log(C_y) - log(sqrt(1 + y_z*y_z));
    return nll;
  }
  real sinhasinh_rng(real mu, real sigma, real eps, real delta) {
    
    return mu + sigma * delta * sinh((asinh(normal_rng(0, 1)) - eps)/delta);
  }
"

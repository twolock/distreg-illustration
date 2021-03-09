# Illustrating Distributional Sinh-arcsinh Regression Models in `brms`

Illustrating how to fit sinh-arcsinh distributional models in `brms`

This repository accompanies Wolock *et al.* (2021). In `Illustration.html`, we provide a short demonstration of fitting a series of increasingly complex distributional models to simulated data using `brms`.

Here, we provide very brief instructions for fitting sinh-arcsinh models.

## Quick Start

This is a hacky way to get started with sinh-arcsinh distirbution models in `brms`.

Add the following lines to your R script *before* calling `brm`:

```{r}
source('https://raw.githubusercontent.com/twolock/distreg-illustration/main/R/stan_funs.R')
stanvars <- stanvar(scode = stan_funs, block = "functions")
```

Use the `sinhasinh` family in the call to `brm` and include the `stanvars` defined above:

```{r}
brm_fit <- brm(formula = my_fm,
               data = my_data,
               family = sinhasinh,
               stanvars = stanvars)
```

And finally, to get access to things like posterior prediction, run this line *after* the call the `brm`.

```{r}
expose_functions(brm_fit, vectorize = T, show_compiler_warnings=F)
```

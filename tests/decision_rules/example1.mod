/*
 * Example 1 from F. Collard (2001): "Stochastic simulations with DYNARE:
 * A practical guide" (see "guide.pdf" in the documentation directory).
 */

/*
 * Copyright (C) 2001-2010 Dynare Team
 *
 * This file is part of Dynare.
 *
 * Dynare is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Dynare is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Dynare.  If not, see <http://www.gnu.org/licenses/>.
 */


var y, c, k, a, h, b;
varexo e, u;

parameters beta, rho, alpha, delta, theta, psi, tau;

alpha = 0.36;
rho   = 0.95;
tau   = 0.025;
beta  = 0.99;
delta = 0.025;
psi   = 0;
theta = 2.95;

phi   = 0.1;

model;
c*theta*h^(1+psi)=(1-alpha)*y;
k = beta*(((exp(b)*c)/(exp(b(+1))*c(+1)))
    *(exp(b(+1))*alpha*y(+1)+(1-delta)*k));
y = exp(a)*(k(-1)^alpha)*(h^(1-alpha));
k = exp(b)*(y-c)+(1-delta)*k(-1);
a = rho*a(-1)+tau*b(-1) + e;
b = tau*a(-1)+rho*b(-1) + u;
end;

initval;
y = 1.08068253095672;
c = 0.80359242014163;
h = 0.29175631001732;
k = 11.08360443260358;
a = 0;
b = 0;
e = 0;
u = 0;
end;

shocks;
var e; stderr 0.009;
var u; stderr 0.009;
var e, u = phi*0.009*0.009;
end;

steady(solve_algo=4,maxit=1000);
stoch_simul;

if ~isoctave() && ~matlab_ver_less_than('8.4')
   websave('example1_results_dyn_432.mat','http://www.dynare.org/Datasets/example1_results_dyn_432.mat')
else
   urlwrite('http://www.dynare.org/Datasets/example1_results_dyn_432.mat','example1_results_dyn_432.mat')
end

dyn_432_results=load('example1_results_dyn_432.mat');

if max(max(abs(oo_.dr.ghx-dyn_432_results.oo_.dr.ghx)))>1e-6 || max(max(abs(oo_.dr.ghu-dyn_432_results.oo_.dr.ghu))) >1e-6
    error('First order decision rules wrong')
end

if max(max(abs(oo_.dr.ghxx-dyn_432_results.oo_.dr.ghxx)))>1e-6 || max(max(abs(oo_.dr.ghuu-dyn_432_results.oo_.dr.ghuu))) >1e-6 ...
        || max(max(abs(oo_.dr.ghxu-dyn_432_results.oo_.dr.ghxu))) >1e-6 || max(max(abs(oo_.dr.ghs2-dyn_432_results.oo_.dr.ghs2))) >1e-6
    error('Second order decision rules wrong')
end



DEFINE hcreg (dv =!charend ('/')/iv =!charend ('/')
             /test = !charend('/') !default (0)
             /const = !charend('/') !default(1)
             /method = !charend ('/') !default (3)
             /covmat = !charend('/') !default(0)).
PRESERVE.
set length = none.
SET MXLOOP = 100000000.
MATRIX.
GET x/file = */variables = !dv !iv/names = dv/missing = omit.
compute y=x(:,1).
compute x=x(:,2:ncol(x)).
compute iv5 = x.
compute pr = ncol(x).
compute n = nrow(x).
compute L = ident(pr).
compute tss=cssq(y)-(((csum(y)&**2)/n)*(!const <> 0)).
do if (!const = 0).
  compute iv = t(dv(1,2:ncol(dv))).
  compute df2 = n-pr.
else.
  compute iv = t({"Constant", dv(1,2:ncol(dv))}).
  compute con = make(n,1,1).
  compute x={con,x}.
  compute df2 = n-pr-1.
  compute L1 = make(1,pr,0).
  compute L = {L1;L}.
end if.
compute dv=dv(1,1).
compute b = inv(t(x)*x)*t(x)*y.
compute k = nrow(b).
compute invXtX = inv(t(x)*x).
compute h = x(:,1).
loop i=1 to n.
  compute h(i,1)= x(i,:)*invXtX*t(x(i,:)).
end loop.
compute resid = (y-(x*b)).
compute mse = csum(resid&**2)/(n-ncol(x)).
compute pred = x*b.
compute ess= cssq(resid).
 do if (!method = 2 or !method = 3).
  loop i=1 to k.
    compute x(:,i) = (resid&/(1-h)&**(1/(4-!method)))&*x(:,i).
  end loop.
 end if.
 do if (!method = 0 or !method = 1).
  loop i=1 to k.
    compute x(:,i) = resid&*x(:,i).
  end loop.
 end if.
 do if (!method = 5).
   loop i=1 to k.
    compute x(:,i) = sqrt(mse)&*x(:,i).
  end loop.
 end if.
do if (!method = 4).
 compute mn = make(n,2,4).
 compute pr3 = n-df2.
 compute mn(:,2) = (n*h)/pr3.
 compute ex=rmin(mn).
  loop i=1 to k.
    compute x(:,i) = (resid&/(1-h)&**(ex/2))&*x(:,i).
  end loop.
 end if.
compute hc = invXtX*t(x)*x*invXtX.
do if (!method = 1).
  compute hc = (n/(n-k))&*hc.
end if.
compute F = (t(t(L)*b)*inv(t(L)*hc*L)*((t(L)*b)))/pr.
compute pf = 1-fcdf(f,pr,df2).
compute r2 = (tss-ess)/tss.
compute pf = {r2,f,pr,df2,pf}.
do if (!method <> 5).
print !method/title = "HC Method"/format F1.0.
end if.
print dv/title = "Criterion Variable"/format A8.
print pf/title = "Model Fit:"/clabels = "R-sq" "F" "df1" "df2" "p"/format F10.4.
compute sebhc = sqrt(diag(hc)).
compute te = b&/sebhc.
compute p = 2*(1-tcdf(abs(te), n-nrow(b))).
compute oput = {b,sebhc, te, p}.
do if (!method <> 5).
print oput/title = 'Heteroscedasticity-Consistent Regression Results'/clabels 
       = "Coeff" "SE(HC)" "t" "P>|t|"/rnames = iv/format f10.4.
else if (!method = 5).
print oput/title = 'OLS Regression Results Assuming Homoscedasticity'/clabels 
       = "Coeff" "SE" "t" "P>|t|"/rnames = iv/format f10.4.
end if.
compute iv2 = t(iv).
do if (!covmat = 1).
print hc/title = 'Covariance Matrix of Parameter Estimates'/cnames = 
      iv/rnames = iv2/format f10.4.
end if.
do if (!test > 0 and !test < pr).
 compute L2 = make(pr-!test+!const,!test,0).
 compute L = {L2;L((pr+1-!test+!const):(pr+!const),(pr-!test+1):(pr))}.
 compute F = (t(t(L)*b)*inv(t(L)*hc*L)*((t(L)*b)))/!test.
 compute pf = 1-fcdf(f,!test,df2).
 compute pf = {f,!test,df2,pf}.
 print pf/title = "Setwise Hypothesis Test"
    /clabels = "F" "df1" "df2" "p"/format F10.4.
 compute iv = t(iv((pr+1-!test+!const):(pr+!const),1)).
 print iv/title = "Variables in Set:"/format A8.
end if.
END MATRIX.
RESTORE.
!ENDDEFINE.

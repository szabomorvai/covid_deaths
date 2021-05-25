*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , append ctitle(${title}) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , append ctitle(${title}) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
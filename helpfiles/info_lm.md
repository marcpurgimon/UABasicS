Model Lineal General
==========================

El Model Lineal General és una generalització dels models de regressió lineal i d'anàlisi de la variància.

És a dir, és un model amb una variable resposta numèrica i variables explicatives tant numèriques com factor. La regressió lineal només accepta variables predictores numèriques, i l'ANOVA factors.

Ha de complir la següent estructura:

$$Y = \beta_0+\beta_1X_1+\beta_2X_2+...+\beta_kX_k+\epsilon$$

- No ha de faltar cap variable important al model.

- L'error $\epsilon$ ha de seguir una distribució Normal amb mitjana 0 i desviació típica constant.

- Els paràmetres $\beta_i$ s'estimen pel mètode de mínims quadrats, que pretén minimitzar la distància entre la recta de regressió i els punts, és a dir, la distància entre la predicció i els punts observats.

$$H_0: \beta_i = 0$$
$$H_1: \beta_i \neq 0$$

Si un paràmetre té un coeficient amb un p-valor < 0.05, llavors el pendent és estadísticament no nul, és a dir, hi ha evidències per afirmar que el coeficient no és 0.

## Interpretació coeficients

- $\beta_0$ és una constant. És el valor de Y quan totes les variables explicatives tenen un valor de 0. Per tant, si l'intercept és -5, el valor de la variable resposta `y` és -5, si les variables explicatives són constants.

- $\beta_i, \forall{i>0}$: Si la variable $X_i$ augmenta 1 unitat, el valor de la variable resposta `y` augmentarà $\beta_i$.

- Si una variable explicativa és un factor, hi ha un dels nivells que està de referència: el que no apareix a la sortida del model. Els coeficients dels altres nivells s'interpreten com a: si el coeficient és positiu, el valor de `y` millora respecte el nivell de referència.

## Mètrica

- El coeficient de determinació, $R^2$, mesura el % d'explicació de la variabilitat de les dades del model. El rang és de 0 a 1 i és el quadrat del coeficient de correlació. Si és proper a 1, la relació és forta. Si està entre 0.5 i 0.75, es considera moderada. Si és menys de 0.5 ja es considera feble. Com més proper a 0, més feble.


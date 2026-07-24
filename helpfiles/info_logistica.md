Model de Regressió Logística
=============================

Es tracta d'un model, la variable resposta del qual és binària:

* 1: Sí / èxit
* 0: No / fracàs

No és un model lineal, pretén modelitzar una probabilitat. Les variables explicatives, com en el Model Lineal General, poden ser tant numèriques com factor.

Per tal de transformar-se en un model lineal, utilitza la transformació \em{logit}:

$$ln(odds) = ln(\frac{p}{1-p})=\beta_0+\beta_1X_1+\beta_2X_2+...+\beta_kX_k$$

Els `odds` quantifiquen els èxits en relació als fracassos.

Els coeficients s'estimen pel mètode de Màxima Versemblança.

## Interpretació coeficients

* Si la variable explicativa és numèrica, llavors, per a l'augment de cada unitat d'aquesta variable, augmenta els odds $exp(\beta_i)$ vegades.

* Si la variable explicativa és binària, llavors, els individus amb $X_i=1$ tenen $exp(\beta_i)$ vegades els odds que el nivell de referència $X_i=0$.

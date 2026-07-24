Informació anàlisi bivariant
============================

## Possibles combinacions de variables

* `y` numèrica vs `x` numèrica
* `y` numèrica vs `x` factor
* `y` factor vs `x` factor


## Recordatori contrastos d'hipòtesis

Un **p-valor** és **estadísticament significatiu** si és `<0.05`, és a dir, rebutgem la hipòtesi nul·la ($H_0$) i n'acceptem l'alternativa ($H_1$).

Si el p-valor està entre 0.05 i 0.10, podem considerar-lo estadísticament significatiu amb un nivell de significació del 10%.

* **Contrast de Normalitat (Shapiro-Wilks):**
  $$H_0: x_i = N(\mu_i, \sigma^2_i)$$
  $$H_1:x_i \neq N(\mu_i, \sigma^2_i)$$
  
  On `i` és cada grup.
  
  Les dades són **Normals** si el **p-valor $\geq$ 0.05**. Si tots els grups són Normals es fa un contrast de mitjanes mitjançant el **T-Test** (`2 grups`) o la **Prova ANOVA** (`>2 grups`).
  
  En aquesta app la prova de Normalitat es fa internament però no es mostra.
  

* **Contrast d'igualtat de variàncies (Bartlett):**
  
  (Condició: Variables Normals)
  $$H_0: \sigma^2_1 = \sigma^2_1 = ... = \sigma^2_k$$
  $$H_1: \sigma^2_m\neq\sigma^2_p$$  

  on `k` és el nombre de grups, i `m` i `p` 2 grups qualssevol.
  
  Es compleix la condició d'igualtat de variàncies si no es rebutja la hipòtesi nul·la ($H_0$), és a dir, el p-valor és $\geq0.05$.
  
  
* **Contrast de mitjanes:**
  (Condicions: Variables Normals i igualtat de variàncies)
  * **T-Test (2 grups):**
  $$H_0:\mu_1-\mu_2 = 0\leftrightarrow\mu_1=\mu_2$$
  $$H_1:\mu_1-\mu_2\neq0\leftrightarrow\mu_1\neq\mu_2$$
  
  Si el **p-valor<0.05** rebutgem la hipòtesi nul·la d'igualtat de mitjanes $\rightarrow$ **hi ha diferències estadísticament significatives entre els grups**.
  
  * **ANOVA (> 2 grups)**
  $$H_0:\mu_1=\mu_2=...=\mu_k$$
  $$H_1:\mu_m\neq\mu_p$$
  
  on `k` és el nombre de grups, i `m` i `p` 2 grups qualssevol. És a dir, rebutgem la hipòtesi nul·la si algun dels grups té diferent mitjana. Per tant, **si el p-valor<0.05 hi ha diferències estadísticament significatives GLOBALMENT entre els grups**.


* **Contrast de medianes (no paramètric):**

  Es duu a terme si les dades **NO són Normals**.
  
  * **Mann-Whitney-Wilcoxon (2 grups):**
  $$H_0:mediana_1-mediana_2 = 0\leftrightarrow mediana_1=mediana_2$$
  $$H_1:mediana_1-mediana_2\neq0\leftrightarrow mediana_1\neq mediana_2$$
  
  Si el **p-valor<0.05** rebutgem la hipòtesi nul·la d'igualtat de medianes $\rightarrow$ **hi ha diferències estadísticament significatives entre els grups**.

  * **Kruskal-Wallis (> 2 grups):**
  $$H_0:mediana_1=mediana_2=...=mediana_k$$
  $$H_1:mediana_m\neq mediana_p$$
  
  Si el **p-valor<0.05** rebutgem la $H_0$ d'igualtat de medianes $\rightarrow$ **hi ha diferències estadísticament significatives GLOBALMENT entre els grups**.


* **Contrastos 2 a 2:**
  
  (Condició: Hi ha més de `k` grups i hi ha diferències estadísticament entre grups globalment)

  Per a cada combinació de grups, fer un T-Test o un contrast de Wilcoxon, segons si són Normals o no.
  
  Apliquem la correcció de multiplicitat de contrastos, amb el mètode **Bonferroni**.
  


* **Contrast d'homogeneïtat de grups:**

  (2 variables categòriques (factors))
  
  $$H_0: \text{Els grups són homogenis}$$
  $$H_1:\text{Els grups NO són homogenis}$$
  
  Calculem la taula de freqüències de la prova **\chi^2** (no es mostrarà aquí):
  
  * **Prova \chi^2:** S'utilitza per defecte. Hi ha d'haver almenys un 80% de cel·les amb una freqüència esperada de $\geq5$ (Cochran).
  
  * **Prova Exacta de Fisher:** Altrament.

  Si el **p-valor<0.05** rebutgem la hipòtesi nul·la d'homogeneïtat. $\rightarrow$ **Hi ha difererències estadísticament significatives en la distribució de la variable `y`respecte la variable grup `x`**.



* **Contrast de correlació:**
  
  Coeficient de correlació $r\in[-1,1]$
  
  $r \approx 0 \rightarrow$ Relació nul·la
  $r \approx 1 \rightarrow$ Relació perfecta positiva
  $r \approx -1 \rightarrow$ Relació perfecta negativa
  
  $$H_0: r = 0$$
  $$H_1: r \neq 0$$
  
  Si el p-valor és < 0.05 $\rightarrow$ **El coeficient de correlació és estadísticament diferent de 0**.
  
  
  * **Coeficient de correlació de Pearson:** Si les dades són Normals.
  
  * **Coeficient de correlació d'Spearman:** Altrament.
  
  

  

  
## Anàlisis

### `y` numèrica vs `x` numèrica


* **Mostres relacionades (ex: inicial vs final):**
  Hauràs de marcar la opció de mostres relacionades.
  * **DESCRIPTIVA**: Diagrama de caixes (`boxplot`) i taula numèrica (Nº d'observacions, mínim, quartils, mitjana, màxim i desviació típica) i diagrama de caixes per grups.
)
  * **INFERÈNCIA**: 
    * Si les dades són Normals: t-test aparellat.
    * Altrament, Mann-Whitney-Wilcoxon aparellat.

* **Mostres independents (ex: edat vs pes):**
  * **DESCRIPTIVA**: Diagrama de punts (`scatterplot`).
  * **INFERÈNCIA**: Contrast de correlació.
    * Si les dades són Normals: Pearson.
    * Altrament, Spearman.
    

### `y`numèrica vs `x` factor

* **DESCRIPTIVA**: Taula de resum numèric (Nº d'observacions, mínim, quartils, mitjana, màxim i desviació típica) i diagrama de caixes per grups.

* **INFERÈNCIA**:
  * **2 grups:**
    * Dades Normals: contrast de mitjanes $\rightarrow$ T-Test
    * NO Normalitat: contrast no paramètric de medianes $\rightarrow$ Mann-Whitney-Wilcoxon
  * **Més de 2 grups:**
    * Dades Normals: contrast de mitjanes $\rightarrow$ amb ANOVA
    * Dades NO Normals: contrast no paramètric de medianes, amb Kruskal-Wallis.
    * Si el contrast global ANOVA o Kruskal-Wallis surt estadísticament significatiu: contrastos 2 a 2 corregint per Bonferroni

### `y` factor vs `x` factor

* **DESCRIPTIVA**: taula de contingència i diagrama de barres apilades.
* **INFERÈNCIA**:
  * $\chi^2$: Més del 80% de les cel·les tenen freqüència esperada de 5 o més.
  * Altrament, Fisher.


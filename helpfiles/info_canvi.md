Canvi variables
====================================

Sovint algunes variables estan carregades en un format erroni.


## Variables categòriques (`factor`)


Les variables categòriques han d'estar en format `factor` per a ser analitzades. 

Casos que s'han de corregir:

- Sovint estan en format `character`. 

- Si veus una variable que està en format `numeric` però en el resum de dades observes, per exemple, que el mínim i màxim són 0 i 1, i les altres mètriques són o 0 o 1, però la mitjana està en decimals, segurament serà una categoria binària, on 0 = No / fracàs i 1 = Sí / èxit, o similar. Hauries de transformar-la a `factor`.

- Si està en format `logic`, és a dir, `TRUE` o `FALSE`.

- Si hi ha una escala de valoració que vols mesurar com a `factor`. Per exemple, 1, 2, 3, 4, 5. Pots fer anàlisi tant numèric com categòric.

Si veus que diu `ord. factor` significa que la variable és un factor ordenat. No has de canviar res.


## Variables numèriques (`numeric`)

Podria haver-hi el cas que hi hagués alguna variable en format `character` o `factor` que en realitat sigui numèrica.


Com he explicat anteriorment, les variables escalars es poden mesurar, tant com a variables numèriques com també categòriques, depenent de si t'interessa calcular la freqüència o la mitjana i dispersió.


Si veus que la variable està en format `integer`, no hi ha problema perquè és una variable numèrica entera.
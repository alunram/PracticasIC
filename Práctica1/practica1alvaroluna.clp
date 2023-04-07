;;;; Practica 1 Ingenieria del conocimiento ;;;;;;;
;;;; Alvaro Luna Ramirez, 4º DGIIM ;;;;;
;;;; HECHOS GENERALES DEL SISTEMA ;;;;;
;;;;(seran validos para todas las ejecuciones del sistema);;;;

; Listado de personas de la familia en cuestion introduccidas con la propiedad unaria de hombre o mujer
(deffacts personas
   (hombre Saturio) ; "Saturio es un hombre"
   (hombre Ignacio)
   (hombre Jesus)
   (hombre JuanIgnacio)
   (hombre Fernando)
   (hombre LuisJavier)
   (hombre Luis)
   (hombre Javier)
   (hombre Alvaro)
   (hombre Alberto)
   (hombre Pablo)
   (hombre Leo)
   (hombre Fer)
   (mujer Socorro)         ; "Socorro es una mujer"
   (mujer Paloma)
   (mujer Margarita)
   (mujer Cristina)
   (mujer Pilar)
   (mujer Maleni)
   (mujer Alicia)
   (mujer Maria)
   (mujer Elena)
   (mujer Bea) )

;;;;; Plantilla tipica de Relaciones binarias, ajustada a relaciones de parentesco restringiendo los valores de tipo de relacion a estas. Se usa para registrar "El <sujeto> es <tipo de relacion> de <objeto>", por ejemplo "Juan es TIO de Julia" 
(deftemplate Relacion 
  (slot tipo (type SYMBOL) (allowed-symbols HIJO PADRE ABUELO NIETO HERMANO ESPOSO PRIMO TIO SOBRINO  CUNIADO YERNO SUEGRO))
  (slot sujeto)
  (slot objeto))

;;;;; Datos de la relacion HIJO y ESPOSO en mi familia que es suficiente para el problema, pues el resto se deduce de estas
(deffacts relaciones
   (Relacion (tipo HIJO) (sujeto Ignacio) (objeto Saturio)) ; "Ignacio es HIJO de Saturio"
   (Relacion (tipo HIJO) (sujeto Jesus) (objeto Saturio))
   (Relacion (tipo HIJO) (sujeto Paloma) (objeto Saturio))
   (Relacion (tipo HIJO) (sujeto Margarita) (objeto Saturio))
   (Relacion (tipo HIJO) (sujeto Cristina) (objeto Saturio))
   (Relacion (tipo HIJO) (sujeto JuanIgnacio) (objeto Ignacio))
   (Relacion (tipo HIJO) (sujeto Luis) (objeto LuisJavier))
   (Relacion (tipo HIJO) (sujeto Javier) (objeto LuisJavier))
   (Relacion (tipo HIJO) (sujeto Alvaro) (objeto LuisJavier))
   (Relacion (tipo HIJO) (sujeto Alberto) (objeto Ignacio))
   (Relacion (tipo HIJO) (sujeto Pablo) (objeto Ignacio))
   (Relacion (tipo HIJO) (sujeto Alicia) (objeto Jesus))
   (Relacion (tipo HIJO) (sujeto Maria) (objeto Ignacio))
   (Relacion (tipo HIJO) (sujeto Elena) (objeto Jesus))
   (Relacion (tipo HIJO) (sujeto Fer) (objeto Fernando))
   (Relacion (tipo ESPOSO) (sujeto Saturio) (objeto Socorro)) ; "Antonio es ESPOSO de Laura"
   (Relacion (tipo ESPOSO) (sujeto Ignacio) (objeto Pilar)) 
   (Relacion (tipo ESPOSO) (sujeto Fernando) (objeto Paloma))
   (Relacion (tipo ESPOSO) (sujeto Jesus) (objeto Maleni))
   (Relacion (tipo ESPOSO) (sujeto LuisJavier) (objeto Cristina))
   (Relacion (tipo ESPOSO) (sujeto Pablo) (objeto Bea))
   (Relacion (tipo ESPOSO) (sujeto Leo) (objeto Maria)))

;;;;;;; Cada relacion tiene una relacion dual que se produce al cambiar entre si objeto y sujeto. Por ejejmplo, Si x es HIJO de y, y es PADRE de x". Para poder deducirlo con una sola regla metemos esa informacion como hechos con la etiqueta dual, "Dual de HIJO PADRE", y asi con todas las relaciones consideradas
(deffacts duales
(dual HIJO PADRE) (dual ABUELO NIETO) (dual HERMANO HERMANO) 
(dual ESPOSO ESPOSO) 
(dual PRIMO PRIMO) (dual TIO SOBRINO) 
(dual CUNIADO CUNIADO) 
(dual YERNO SUEGRO))

(deffacts compuestos
(comp HIJO HIJO NIETO) (comp PADRE PADRE ABUELO) (comp ESPOSO PADRE PADRE)(comp HERMANO PADRE TIO) (comp HERMANO ESPOSO CUNIADO) (comp ESPOSO HIJO YERNO) (comp ESPOSO HERMANO CUNIADO) (comp HIJO PADRE HERMANO) (comp ESPOSO CUNIADO CUNIADO) (comp ESPOSO TIO TIO)  (comp HIJO TIO PRIMO)  ) 

;;;;;; Para que cuando digamos por pantalla el parentesco lo espresemos correctamente, y puesto que el nombre que hemos puesto a cada relacion es el caso masculino, vamos a meter como hechos como se diaria esa relacion en femenino mediante la etiqueta femenino
(deffacts femenino
(femenino HIJO HIJA) (femenino PADRE MADRE) (femenino ABUELO ABUELA) (femenino NIETO NIETA) (femenino HERMANO HERMANA) (femenino ESPOSO ESPOSA) (femenino PRIMO PRIMA) (femenino TIO TIA) (femenino SOBRINO SOBRINA) (femenino CUNIADO CUNIADA) (femenino YERNO NUERA) (femenino SUEGRO SUEGRA)) 


;;;;; REGLAS DEL SISTEMA ;;;;;
;;;; La dualidad es simetrica: si r es dual de t, t es dual de r. Por eso solo metimos como hecho la dualidad en un sentidos, pues en el otro lo podiamos deducir con esta regla
(defrule autodualidad
        (dual ?r ?t)
    => 
        (assert (dual ?t ?r)))

;;;; Si  x es R de y, entonces y es dualdeR de x
(defrule dualidad
        (Relacion (tipo ?r) (sujeto ?x) (objeto ?y))
        (dual ?r ?t)
    => 
        (assert (Relacion (tipo ?t) (sujeto ?y) (objeto ?x))))

;;;; Si  y es R de x, y x es T de z entonces y es RoT de z
;;;; añadimos que z e y sean distintos para evitar que uno resulte hermano de si mismo y cosas asi.
(defrule composicion
        (Relacion (tipo ?r) (sujeto ?y) (objeto ?x))
        (Relacion (tipo ?t) (sujeto ?x) (objeto ?z))
        (comp ?r ?t ?u)
        (test (neq ?y ?z))
    => 
        (assert (Relacion (tipo ?u) (sujeto ?y) (objeto ?z))))

;;;;; Como puede deducir que tu hermano es tu cuñado al ser el esposo de tu cuñada, eliminamos los cuñados que sean hermanos
(defrule limpiacuniados
        (Relacion (tipo HERMANO) (sujeto ?x) (objeto ?y))
        ?f <- (Relacion (tipo CUNIADO) (sujeto ?x) (objeto ?y))
    =>
	    (retract ?f) )


;PREGUNTAS POR PANTALLA:
(defrule pregunta
        (declare (salience 1000)) 
    =>
        (printout t "Dime el nombre de la primera persona de la Familia Ramirez sobre la que quieres informacion (escribe solo el nombre): " crlf)
        (assert (primerapersona (read))))
   
   ;;;;; Solicitamos la relacion que queremos mirar 
   ;;;;; como relacion se tiene que introducir: HIJO, PADRE, ABUELO, NIETO, PRIMO, etc.
   ;;;;; (en mayusculas)
(defrule pregunta2
        (declare (salience 100))
        (primerapersona ?primero)
    =>
        (printout t "Dime la relacion (en mayusculas) de la que quieres saber los familiares de " ?primero ": " crlf)
        (assert (relacionbuscada (read))))

;;;;; Hacemos que nos diga por pantalla la relacion entre las persona introducida. Como la forma de expresarlo dependera del sexo, usamos dos reglas, una para cada sexo
(defrule relacionmasculino
        (primerapersona ?x)		
        (relacionbuscada ?r)
        (Relacion (tipo ?r) (sujeto ?y) (objeto ?x))
        (hombre ?y)
    =>
        (printout t ?y " es " ?r " de " ?x crlf) )

(defrule relacionfemenino
        (primerapersona ?x)		
        (relacionbuscada ?r)
        (Relacion (tipo ?r) (sujeto ?y) (objeto ?x))
        (mujer ?y)
        (femenino ?r ?t)
    =>
        (printout t ?y " es " ?t " de " ?x crlf) )

(defrule notiene
        (primerapersona ?x)		
        (relacionbuscada ?r)
        (not(Relacion (tipo ?r) (sujeto ?y) (objeto ?x)))
    =>
        (printout t ?x " no tiene ningun familiar con relacion: " ?r crlf))


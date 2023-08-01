;;;; Practica 5 Ingenieria del conocimiento ;;;;;;;
;;;; Alvaro Luna Ramirez, 4º DGIIM ;;;;;
;;;; Logica por defecto: Ejercicio sobre animales que vuelan ;;;;;

;;;;;;;;;;;;;;;;;;Representación ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (ave ?x) representa “?x es un ave ”
; (animal ?x) representa “?x es un animal”
; (vuela ?x si|no seguro|por_defecto) representa
;“?x vuela si|no con esa certeza”

;;;;;;;;;;;;;;;;;;;Hechos
;Las aves y los mamíferos son animales
;Los gorriones, las palomas, las águilas y los pingüinos son aves
;La vaca, los perros y los caballos son mamíferos
;Los pingüinos no vuelan

;guardamos los animales que vienen dados en el problema
(deffacts datos
    (ave gorrion)
    (ave paloma)
    (ave aguila)
    (ave pinguino)
    (mamifero vaca)
    (mamifero perro)
    (mamifero caballo)
    (vuela pinguino no seguro)
)

;;;;;;;;;;;;;;;;;;;Reglas seguras
; Las aves son animales
(defrule aves_son_animales
    (ave ?x)
    =>
    (assert (animal ?x))
    (bind ?expl (str-cat "sabemos que un " ?x " es un animal porque las aves son
    un tipo de animal"))
    (assert (explicacion animal ?x ?expl))
)

; Los mamiferos son animales (A3)
(defrule mamiferos_son_animales
    (mamifero ?x)
    =>
    (assert (animal ?x))
    (bind ?expl (str-cat "sabemos que un " ?x " es un animal porque los
    mamiferos son un tipo de animal"))
    (assert (explicacion animal ?x ?expl))
)
; añadimos un hecho que contiene la explicacion de la deduccion

;;;;;;;;;;;;;;;;;;;Regla por defecto: añade 

;;; Casi todos las aves vuela --> puedo asumir por defecto que las aves vuelan
; Asumimos por defecto
(defrule ave_vuela_por_defecto
    (declare (salience -1)) ; para disminuir probabilidad de añadir erróneamente
    (ave ?x)
    =>
    (assert (vuela ?x si por_defecto))
    (bind ?expl (str-cat "asumo que un " ?x " vuela, porque casi todas las aves
    vuelan"))
    (assert (explicacion vuela ?x ?expl))
)

;;;;;;;;;;;;;;;;;;;Regla por defecto: retracta
; Retractamos cuando hay algo en contra
(defrule retracta_vuela_por_defecto
    (declare (salience 1))
    ; para retractar antes de inferir cosas erroneamente
    ?f<- (vuela ?x ?r por_defecto)
    (vuela ?x ?s seguro)
    =>
    (retract ?f)
    (bind ?expl (str-cat "retractamos que un " ?x " " ?r " vuela por defecto, porque
    sabemos seguro que " ?x " " ?s " vuela"))
    (assert (explicacion vuela ?x ?expl))
)
; COMENTARIO: esta regla tambien elimina los por defecto cuando ya esta seguro

;;;;;;;;;;;;;;;;;;; Regla por defecto para razonar con informacion
;;; La mayor parte de los animales no vuelan --> puede interesarme asumir por defecto que un animal no va a volar
(defrule mayor_parte_animales_no_vuelan
    (declare (salience -2)) ;;;; es mas arriesgado, mejor después de otros razonamientos
    (animal ?x)
    (not (vuela ?x ? ?))
    =>
    (assert (vuela ?x no por_defecto))
    (bind ?expl (str-cat "asumo que " ?x " no vuela, porque la mayor parte de los animales no vuelan"))
    (assert (explicacion vuela ?x ?expl))
)


;;;;;;;;;;;;;;;;;;; Ejercicio:
;Completar esta base de conocimiento para que el sistema pregunte
;que de qué animal esta interesado en obtener información sobre si
;vuela y:
;- si es uno de los recogidos en el conocimiento indique si vuela o no
;- si no es uno de los recogidos pregunte si es un ave o un mamífero y
;según la respuesta indique si vuela o no.
;- Si no se sabe si es un mamífero o un ave también responda según el
;razonamiento por defecto indicado

;se pregunta por el animal
(defrule pregunta
    =>
    (printout t "Dime un animal para indicarte si vuela" crlf)
    (bind ?animal (read))
    (assert (preguntado ?animal))
)

;si no era uno de los que teniamos, preguntamos si es mamifero o ave
(defrule animal_nuevo
    (declare (salience -3))
    ?f <- (preguntado ?animal)
    (not (or (mamifero ?animal) (ave ?animal)))
    =>
    (printout t "Dime si el animal que ha introducido, " ?animal ", es un ave o un mamifero (introducir: 'ave' o 'mamifero')" crlf)
    (bind ?respuesta (read))
    (assert (respondido ?animal ?respuesta))
    (retract ?f)
)

;si es ave lo guardamos como tal:
(defrule ave
    (declare (salience -3))
    ?f <- (respondido ?animal ave)
    ;(test (eq ave ?t))
    =>
    (assert (ave ?animal))
    (retract ?f)
    (assert (preguntado ?animal))
)

;si es mamifero lo guardamos como tal:
(defrule mamifero
    (declare (salience -3))
    ?f <- (respondido ?animal mamifero)
    =>
    (retract ?f)
    (assert (mamifero ?animal))
    (assert (preguntado ?animal))
)

;la respuesta tiene que ser "ave" o "mamifero"
; Comprobar que la entrada sea valida
(defrule comprobacion
    (declare (salience -3))
    ?f <- (respondido ?animal ?t)
    (test
        (and
            (neq ?t ave)
            (neq ?t mamifero)
        )
    )
    =>
    (retract ?f)
    (printout t "Opcion no valida. Introduzca 'ave' o 'mamifero'" crlf)
    (assert (preguntado ?animal))
)

;regla para mostrar el resultado si se ha preguntado por un mamifero
(defrule pregunta_mamifero
   (declare (salience -3))
   ?f <- (preguntado ?animal)
   (mamifero ?animal)
   (explicacion vuela ?animal ?expl)
   =>
   (printout t ?animal " es un mamifero y " ?expl crlf)
   (retract ?f)
)

;regla para mostrar el resultado si se ha preguntado por un ave
(defrule pregunta_ave
   (declare (salience -3))
   ?f <- (preguntado ?animal)
   (ave ?animal)
   (explicacion vuela ?animal ?expl)
   =>
   (printout t ?animal " es un ave y " ?expl crlf)
   (retract ?f)
)

;regla para mostrar el resultado si se ha preguntado por un animal desconocido 
(defrule pregunta_desconocido
   (declare (salience -3))
   ?f <- (preguntado ?animal)
   (animal ?animal)
   (not (ave ?animal))
   (not (mamifero ?animal))
   (explicacion vuela ?animal ?expl)
   =>
   (printout t ?animal " es un animal y " ?expl crlf)
   (retract ?f)
)



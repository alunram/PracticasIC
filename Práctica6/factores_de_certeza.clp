;;;; Practica 5 Ingenieria del conocimiento ;;;;;;;
;;;; Alvaro Luna Ramirez, 4º DGIIM ;;;;;
;;;; Factores de certeza: Diagnóstico sobre la avería del coche  ;;;;;

;;;Reglas:
;;Regla 1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujías con certeza 0,7
;;Regla 2: SI NO gira el motor ENTONCES problema con el starter con certeza 0,8
;;Regla 3: SI NO encienden las luces ENTONCES problemas con la batería con certeza 0,9
;;Regla 4: SI hay gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0,9
;;Regla 5: SI hace intentos de arrancar ENTONCES problema con el starter con certeza -0,6
;;Regla 6: SI hace intentos de arrancar ENTONCES problema con la batería 0,5

; (FactorCerteza ?h si|no ?f ?explicacion) representa que ?h se ha deducido con factor de certeza ?f
;?h podrá_ser:
;   - problema_starter
;   - problema_bujias
;   - problema_batería
;   - motor_llega_gasolina
; (Evidencia ?e si|no) representa el hecho de si evidencia ?e se da
; ?e podrá ser:
;   - hace_intentos_arrancar
;   - hay_gasolina_en_deposito
;   - encienden_las_luces
;   - gira_motor

;;;Añadimos explicaciones a la eleccion del resultado final

;;; convertimos cada evidencia en una afirmación sobre su factor de certeza
(defrule certeza_evidencias
    (Evidencia ?e ?r)
    =>
    (bind ?explicacion (str-cat "sin motivo"))
    (assert (FactorCerteza ?e ?r 1 ?explicacion))
)
;; También podríamos considerar evidencias con una cierta
;;incertidumbre: al preguntar por la evidencia, pedir y recoger
;;directamente el grado de certeza

;funcion encadenado
(deffunction encadenado (?fc_antecedente ?fc_regla)
    (if (> ?fc_antecedente 0)
        then
        (bind ?rv (* ?fc_antecedente ?fc_regla))
        else
        (bind ?rv 0) )
?rv)

;combinacion
(deffunction combinacion (?fc1 ?fc2)
    (if (and (> ?fc1 0) (> ?fc2 0) )
        then
        (bind ?rv (- (+ ?fc1 ?fc2) (* ?fc1 ?fc2) ) )
        else
        (if (and (< ?fc1 0) (< ?fc2 0) )
            then
            (bind ?rv (+ (+ ?fc1 ?fc2) (* ?fc1 ?fc2) ) )
            else
            (bind ?rv (/ (+ ?fc1 ?fc2) (- 1 (min (abs ?fc1) (abs ?fc2))) ))
        )
    )
?rv)

;;;TRADUCIR REGLAS:
;;Regla 1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujías con certeza 0,7
(defrule R1
    (FactorCerteza motor_llega_gasolina si ?f1 ?explicacion1)
    (FactorCerteza gira_motor si ?f2 ?explicacion2)
    (test (and (> ?f1 0) (> ?f2 0)))
    =>
    (bind ?explicacionfinal (str-cat "porque el motor gira y obtiene gasolina"))
    (assert (FartorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7) ?explicacionfinal))
)

;;Regla 2: SI NO gira el motor ENTONCES problema con el starter con certeza 0,8
(defrule R2
    (declare (salience 3))
    (Evidencia gira_motor no)
    =>
    (bind ?explicacionfinal (str-cat "porque el motor no gira"))
    (assert (FactorCerteza problema_starter si 0.8 ?explicacionfinal))
)

;;Regla 3: SI NO encienden las luces ENTONCES problemas con la batería con certeza 0,9
(defrule R3
    (declare (salience 3))
    (Evidencia encienden_las_luces no)
    =>
    (bind ?explicacionfinal (str-cat "porque no encienden las luces"))
    (assert (FactorCerteza problema_batería si 0.9 ?explicacionfinal))
)

;;Regla 4: SI hay gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0,9
(defrule R4
    (declare (salience 3))
    (Evidencia hay_gasolina_en_deposito si)
    =>
    (bind ?explicacionfinal (str-cat "porque hay gasolina en el deposito"))
    (assert (FactorCerteza motor_llega_gasolina si 0.9 ?explicacionfinal))
)

;;Regla 5: SI hace intentos de arrancar ENTONCES problema con el starter con certeza -0,6
(defrule R5
    (declare (salience 3))
    (Evidencia hace_intentos_arrancar si)
    =>
    (bind ?explicacionfinal (str-cat "porque hace intentos de arrancar"))
    (assert (FactorCerteza problema_starter si -0.6 ?explicacionfinal))
)

;;Regla 6: SI hace intentos de arrancar ENTONCES problema con la batería 0,5
(defrule R6
    (declare (salience 3))
    (Evidencia hace_intentos_arrancar si)
    =>
    (bind ?explicacionfinal (str-cat "porque hace intentos de arrancar"))
    (assert (FactorCerteza problema_batería si 0.5 ?explicacionfinal))
)

;;;;;; Combinar misma deduccion por distintos caminos
(defrule combinar
    (declare (salience 1))
    ?f <- (FactorCerteza ?h ?r ?fc1 ?explicacion1)
    ?g <- (FactorCerteza ?h ?r ?fc2 ?explicacion2) 
    (test (neq ?fc1 ?fc2))
    =>
    (retract ?f ?g)
    (bind ?explicacionfinal (str-cat ?explicacion1 " y " ?explicacion2))
    (assert (FactorCerteza ?h ?r (combinacion ?fc1 ?fc2) ?explicacionfinal))
)

;Aunque en este ejemplo no se da, puede ocurrir que tengamos
;deducciones de hipótesis en positivo y negativo que hay que
;combinar para compararlas
(defrule combinar_signo
    (declare (salience 2))
    (FactorCerteza ?h si ?fc1 ?explicacion1)
    (FactorCerteza ?h no ?fc2 ?explicacion2)
    =>
    (bind ?explicacionfinal (str-cat ?explicacion1 " y " ?explicacion2))
    (assert (Certeza ?h (- ?fc1 ?fc2)))
)

;;;;;;;;;;;;;;;;;;; Ejercicio:
;Hay que:
;   - preguntar por las posibles evidencias
;   - añadir el resto de las reglas, y
;   - tras razonar quedarse con la hipótesis con mayor certeza
;   - Añadir o modificar las reglas para que el sistema explique el por qué de las
;     afirmaciones

;;;;;;PREGUNTAS
;Se pregunta al usuario sobre si hace_intentos_arrancar
(defrule pregunta_hace_intentos_arrancar
    (declare (salience 4))
    =>
    (printout t "¿El coche hace intentos de arrancar?" crlf)
    (bind ?s (read))
    (while (and (neq ?s si) (neq ?s no))
        (printout t "Responda de nuevo. Solo se permiten respuestas 'si' y 'no'" crlf)
        (bind ?s (read))
    )
    (assert (Evidencia hace_intentos_arrancar ?s))
)

;Se pregunta al usuario sobre si hay_gasolina_en_deposito
(defrule pregunta_hay_gasolina_en_deposito
    (declare (salience 4))
    =>
    (printout t "¿El tiene gasolina en el depósito?" crlf)
    (bind ?s (read))
    (while (and (neq ?s si) (neq ?s no))
        (printout t "Responda de nuevo. Solo se permiten respuestas 'si' y 'no'" crlf)
        (bind ?s (read))
    )
    (assert (Evidencia hay_gasolina_en_deposito ?s))
)

;Se pregunta al usuario sobre si encienden_las_luces
(defrule pregunta_encienden_las_luces
    (declare (salience 4))
    =>
    (printout t "¿Se encienden las luces del coche?" crlf)
    (bind ?s (read))
    (while (and (neq ?s si) (neq ?s no))
        (printout t "Responda de nuevo. Solo se permiten respuestas 'si' y 'no'" crlf)
        (bind ?s (read))
    )
    (assert (Evidencia encienden_las_luces ?s))
)

;Se pregunta al usuario sobre si gira_motor
(defrule pregunta_gira_motor
    (declare (salience 4))
    =>
    (printout t "¿El motor del coche gira?" crlf)
    (bind ?s (read))
    (while (and (neq ?s si) (neq ?s no))
        (printout t "Responda de nuevo. Solo se permiten respuestas 'si' y 'no'" crlf)
        (bind ?s (read))
    )
    (assert (Evidencia gira_motor ?s))
)

;quitamos las evidencias (1)
(defrule quitar_valores_1
    ?f<-(FactorCerteza ?h ?x ?fc ?explicacion)
    ?e<-(Evidencia ?h ?s)
    =>
    (retract ?f ?e)
)

;dejamos la de mayor certeza
(defrule comparar
    ?f1<-(FactorCerteza ?h1 ?x ?fc1 ?explicacion1)
    ?f2<-(FactorCerteza ?h2 ?y ?fc2 ?explicacion2)
    (test (neq ?h1 ?h2))
    =>
    (if (< ?fc1 ?fc2) then
        (retract ?f1)
    )
    (if (> ?fc1 ?fc2) then
        (retract ?f2)
    )
)

;Enseñamos por pantalla el resultado
(defrule resultado
    (FactorCerteza ?h ?x ?fc ?explicacion)
    =>
    (printout t ?h " con certeza " ?fc " " ?explicacion crlf)
)



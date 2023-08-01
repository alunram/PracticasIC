;;;;;;; JUGADOR DE 4 en RAYA ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;; Version de 4 en raya clásico: Tablero de 6x7, donde se introducen fichas por arriba
;;;;;;;;;;;;;;;;;;;;;;; y caen hasta la posicion libre mas abajo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; Hechos para representar un estado del juego

;;;;;;; (Turno M|J)   representa a quien corresponde el turno (M maquina, J jugador)
;;;;;;; (Tablero Juego ?i ?j _|M|J) representa que la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)

;;;;;;;;;;;;;;;; Hechos para representar estado del analisis
;;;;;;; (Tablero Analisis Posicion ?i ?j _|M|J) representa que en el analisis actual la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)
;;;;;;; (Sondeando ?n ?i ?c M|J)  ; representa que estamos analizando suponiendo que la ?n jugada h sido ?i ?c M|J
;;;

;;;;;;;;;;;;; Hechos para representar una jugadas

;;;;;;; (Juega M|J ?columna) representa que la jugada consiste en introducir la ficha en la columna ?columna 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INICIALIZAR ESTADO


(deffacts Estado_inicial
(Tablero Juego 1 1 _) (Tablero Juego 1 2 _) (Tablero Juego 1 3 _) (Tablero Juego  1 4 _) (Tablero Juego  1 5 _) (Tablero Juego  1 6 _) (Tablero Juego  1 7 _)
(Tablero Juego 2 1 _) (Tablero Juego 2 2 _) (Tablero Juego 2 3 _) (Tablero Juego 2 4 _) (Tablero Juego 2 5 _) (Tablero Juego 2 6 _) (Tablero Juego 2 7 _)
(Tablero Juego 3 1 _) (Tablero Juego 3 2 _) (Tablero Juego 3 3 _) (Tablero Juego 3 4 _) (Tablero Juego 3 5 _) (Tablero Juego 3 6 _) (Tablero Juego 3 7 _)
(Tablero Juego 4 1 _) (Tablero Juego 4 2 _) (Tablero Juego 4 3 _) (Tablero Juego 4 4 _) (Tablero Juego 4 5 _) (Tablero Juego 4 6 _) (Tablero Juego 4 7 _)
(Tablero Juego 5 1 _) (Tablero Juego 5 2 _) (Tablero Juego 5 3 _) (Tablero Juego 5 4 _) (Tablero Juego 5 5 _) (Tablero Juego 5 6 _) (Tablero Juego 5 7 _)
(Tablero Juego 6 1 _) (Tablero Juego 6 2 _) (Tablero Juego 6 3 _) (Tablero Juego 6 4 _) (Tablero Juego 6 5 _) (Tablero Juego 6 6 _) (Tablero Juego 6 7 _)
(Jugada 0)
)

(defrule Elige_quien_comienza
=>
(printout t "Quien quieres que empieze: (escribre M para la maquina o J para empezar tu) ")
(assert (Turno (read)))
)

;;;;;;;;;;;;;;;;;;;;;;; MUESTRA POSICION ;;;;;;;;;;;;;;;;;;;;;;;
(defrule muestra_posicion
(declare (salience 10))
(muestra_posicion)
(Tablero Juego 1 1 ?p11) (Tablero Juego 1 2 ?p12) (Tablero Juego 1 3 ?p13) (Tablero Juego 1 4 ?p14) (Tablero Juego 1 5 ?p15) (Tablero Juego 1 6 ?p16) (Tablero Juego 1 7 ?p17)
(Tablero Juego 2 1 ?p21) (Tablero Juego 2 2 ?p22) (Tablero Juego 2 3 ?p23) (Tablero Juego 2 4 ?p24) (Tablero Juego 2 5 ?p25) (Tablero Juego 2 6 ?p26) (Tablero Juego 2 7 ?p27)
(Tablero Juego 3 1 ?p31) (Tablero Juego 3 2 ?p32) (Tablero Juego 3 3 ?p33) (Tablero Juego 3 4 ?p34) (Tablero Juego 3 5 ?p35) (Tablero Juego 3 6 ?p36) (Tablero Juego 3 7 ?p37)
(Tablero Juego 4 1 ?p41) (Tablero Juego 4 2 ?p42) (Tablero Juego 4 3 ?p43) (Tablero Juego 4 4 ?p44) (Tablero Juego 4 5 ?p45) (Tablero Juego 4 6 ?p46) (Tablero Juego 4 7 ?p47)
(Tablero Juego 5 1 ?p51) (Tablero Juego 5 2 ?p52) (Tablero Juego 5 3 ?p53) (Tablero Juego 5 4 ?p54) (Tablero Juego 5 5 ?p55) (Tablero Juego 5 6 ?p56) (Tablero Juego 5 7 ?p57)
(Tablero Juego 6 1 ?p61) (Tablero Juego 6 2 ?p62) (Tablero Juego 6 3 ?p63) (Tablero Juego 6 4 ?p64) (Tablero Juego 6 5 ?p65) (Tablero Juego 6 6 ?p66) (Tablero Juego 6 7 ?p67)
=>
(printout t crlf)
(printout t ?p11 " " ?p12 " " ?p13 " " ?p14 " " ?p15 " " ?p16 " " ?p17 crlf)
(printout t ?p21 " " ?p22 " " ?p23 " " ?p24 " " ?p25 " " ?p26 " " ?p27 crlf)
(printout t ?p31 " " ?p32 " " ?p33 " " ?p34 " " ?p35 " " ?p36 " " ?p37 crlf)
(printout t ?p41 " " ?p42 " " ?p43 " " ?p44 " " ?p45 " " ?p46 " " ?p47 crlf)
(printout t ?p51 " " ?p52 " " ?p53 " " ?p54 " " ?p55 " " ?p56 " " ?p57 crlf)
(printout t ?p61 " " ?p62 " " ?p63 " " ?p64 " " ?p65 " " ?p66 " " ?p67 crlf)
(printout t  crlf)
)


;;;;;;;;;;;;;;;;;;;;;;; RECOGER JUGADA DEL CONTRARIO ;;;;;;;;;;;;;;;;;;;;;;;
(defrule mostrar_posicion
(declare (salience 9999))
(Turno J)
=>
(assert (muestra_posicion))
)

(defrule jugada_contrario
?f <- (Turno J)
=>
(printout t "en que columna introduces la siguiente ficha? ")
(assert (Juega J (read)))
(retract ?f)
)

(defrule juega_contrario_check_entrada_correcta
(declare (salience 1))
?f <- (Juega J ?c)
(test (and (neq ?c 1) (and (neq ?c 2) (and (neq ?c 3) (and (neq ?c 4) (and (neq ?c 5) (and (neq ?c 6) (neq ?c 7))))))))
=>
(printout t "Tienes que indicar un numero de columna: 1,2,3,4,5,6 o 7" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_check_columna_libre
(declare (salience 1))
?f <- (Juega J ?c)
(Tablero Juego 1 ?c ?X) 
(test (neq ?X _))
=>
(printout t "Esa columna ya esta completa, tienes que jugar en otra" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_actualiza_estado
?f <- (Juega J ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego ?i ?c J))
)

(defrule juega_contrario_actualiza_estado_columna_vacia
?f <- (Juega J ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego 6 ?c J))
)


;;;;;;;;;;; ACTUALIZAR  ESTADO TRAS JUGADA DE CLISP ;;;;;;;;;;;;;;;;;;

(defrule juega_clisp_actualiza_estado
?f <- (Juega M ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego ?i ?c M))
)

(defrule juega_clisp_actualiza_estado_columna_vacia
?f <- (Juega M ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego 6 ?c M))
)

;;;;;;;;;;; CLISP JUEGA SIN CRITERIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule elegir_jugada_aleatoria
(declare (salience -9998))
?f <- (Turno M)
=>
(assert (Jugar (random 1 7)))
(retract ?f)
)

(defrule comprobar_posible_jugada_aleatoria
?f <- (Jugar ?c)
(Tablero Juego 1 ?c M|J)
=>
(retract ?f)
(assert (Turno M))
)

(defrule clisp_juega_sin_criterio
(declare (salience -9999))
?f<- (Jugar ?c)
=>
(printout t "JUEGO en la columna (sin criterio) " ?c crlf)
(retract ?f)
(assert (Juega M ?c))
(printout t "Juego sin razonar, que mal"  crlf) 
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;  Comprobar si hay 4 en linea ;;;;;;;;;;;;;;;;;;;;;

(defrule cuatro_en_linea_horizontal
(declare (salience 9999))
(Tablero ?t ?i ?c1 ?jugador)
(Tablero ?t ?i ?c2 ?jugador) 
(test (= (+ ?c1 1) ?c2))
(Tablero ?t ?i ?c3 ?jugador)
(test (= (+ ?c1 2) ?c3))
(Tablero ?t ?i ?c4 ?jugador)
(test (= (+ ?c1 3) ?c4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador horizontal ?i ?c1))
)

(defrule cuatro_en_linea_vertical
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i1 ?c ?jugador)
(Tablero ?t ?i2 ?c ?jugador)
(test (= (+ ?i1 1) ?i2))
(Tablero ?t ?i3 ?c  ?jugador)
(test (= (+ ?i1 2) ?i3))
(Tablero ?t ?i4 ?c  ?jugador)
(test (= (+ ?i1 3) ?i4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador vertical ?i1 ?c))
)

(defrule cuatro_en_linea_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (+ ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (+ ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_directa ?i ?c))
)

(defrule cuatro_en_linea_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (- ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (- ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (- ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_inversa ?i ?c))
)

;;;;;;;;;;;;;;;;;;;; DESCUBRE GANADOR
(defrule gana_fila
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador horizontal ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la fila " ?i crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_columna
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador vertical ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la columna " ?c crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_directa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal que empieza la posicion " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_inversa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal hacia arriba que empieza la posicin " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 


;;;;;;;;;;;;;;;;;;;;;;;  DETECTAR EMPATE

(defrule empate
(declare (salience -9999))
(Turno ?X)
(Tablero Juego 1 1 M|J)
(Tablero Juego 1 2 M|J)
(Tablero Juego 1 3 M|J)
(Tablero Juego 1 4 M|J)
(Tablero Juego 1 5 M|J)
(Tablero Juego 1 6 M|J)
(Tablero Juego 1 7 M|J)
=>
(printout t "EMPATE! Se ha llegado al final del juego sin que nadie gane" crlf)
)

;;;;;;;;;;;;;;;;;;;;;; CONOCIMIENTO EXPERTO ;;;;;;;;;;
;;;;; ¡¡¡¡¡¡¡¡¡¡ Añadir conocimiento para que juege como vosotros jugariais !!!!!!!!!!!!


;;;;;;;;; Practica 2 Ingenieria del conocimiento ;;;;;;;;;;;;
;;;;;;;;; Alvaro Luna Ramirez, 4º DGIIM ;;;;;;;;;;


;;Como no sabia cual es exactamente la mejor tecnica para el juego, decidi empezar por lo basico, siguiendo
;;los ejercicios propuestos. Primero para ver las posiciones siguiente y anterior en las 4 direcciones posibles.
;;Segundo para ver si puede caer una ficha en una posicion del tablero. Despues para ver si hay fichas en linea 
;;(ya sean dos o tres) y si una jugada podria permitir ganar a algun jugador.

;;La idea que sigue la maquina es que si puedes ganar jugando una ficha, lo hagas. Si no, al menos evita que el rival
;;pueda ganarte en el turno siguiente. Si no hay jugadas ganadoras, juega a poner tres fichas propias en linea, y si 
;;no a bloquear al rival. Y si no hay jugadas para bloquear al rival, que ponga una ficha al lado de una propia 
;;(o si no que juegue aleaatorio como estaba ya)

;;;;;;;;;EJERCICIOS PROPUESTOS:
;;;;;Ejercicio 1:  Crear reglas para que el sistema deduzca la posición siguiente y anterior a una posición.
;;;;;hay que hacer reglas para deducir la posicion siguiente y anterior para las 4 direcciones: horizontal(h), vertical(v), diagonal_derecha_abajo (d1) o diagonal_derecha_arriba (d2)
;1: posicion siguiente para direccion horizontal. mira la misma fila y columna=columna+1(columna tiene que ser menor que 7, para no salirnos)
(defrule siguiente_h
    (Tablero ?t ?fila ?columna ?j)
    (test (< ?columna 7))
    =>
    (assert (siguiente ?fila ?columna h ?fila (+ ?columna 1)))
)

;2: posicion anterior para direccion horizontal. mira la misma fila y columna=columna-1 (columna tiene que ser mayor que 1, para no salirnos)
(defrule anterior_h
    (Tablero ?t ?fila ?columna ?j)
    (test (> ?columna 1))
    =>
    (assert (anterior ?fila ?columna h ?fila (- ?columna 1)))
)

;3:posicion siguiente para direccion vertical. mira la misma columna y fila=fila-1(fila tiene que ser mayor que 1, para no salirnos)
(defrule siguiente_v
    (Tablero ?t ?fila ?columna ?j)
    (test (> ?fila 1))
    =>
    (assert (siguiente ?fila ?columna v (- ?fila 1) ?columna ))
)

;4: posicion anterior para direccion vertical. mira la misma columna y fila=fila+1(fila menor que 6, para no salirnos por abajo)
(defrule anterior_v
    (Tablero ?t ?fila ?columna ?j)
    (test (< ?fila 6))
    =>
    (assert (anterior ?fila ?columna v (+ ?fila 1) ?columna ))
)

;5: posicion siguiente para diagonal_derecha_abajo (d1). mira columna=columna+1 y fila=fila+1 (hay que ver que fila<6 y columna<7, para no salirnos)
(defrule siguiente_d1
    (Tablero ?t ?fila ?columna ?j)
    (test (< ?fila 6))
    (test (< ?columna 7))
    =>
    (assert (siguiente ?fila ?columna d1 (+ ?fila 1) (+ ?columna 1) ))
)

;6:posicion anterior para diagonal_derecha_abajo (d1). mira columna=columna-1 y fila=fila-1 (hay que ver que fila>1 y columna>1, para no salirnos)
(defrule anterior_d1
    (Tablero ?t ?fila ?columna ?j)
    (test (> ?fila 1))
    (test (> ?columna 1))
    =>
    (assert (anterior ?fila ?columna d1 (- ?fila 1) (- ?columna 1) ))
)

;7:posicion siguiente para diagonal_derecha_arriba (d2). mira columna=columna+1 y fila=fila-1 (hay que ver que fila>1 y columna<7, para no salirnos)
(defrule siguiente_d2
    (Tablero ?t ?fila ?columna ?j)
    (test (> ?fila 1))
    (test (< ?columna 7))
    =>
    (assert (siguiente ?fila ?columna d2 (- ?fila 1) (+ ?columna 1) ))
)

;8:posicion anterior para diagonal_derecha_arriba (d2). mira columna=columna-1 y fila=fila+1 (hay que ver que fila<6 y columna>1, para no salirnos)
(defrule siguiente_d2
    (Tablero ?t ?fila ?columna ?j)
    (test (< ?fila 6))
    (test (> ?columna 1))
    =>
    (assert (anterior ?fila ?columna d2 (+ ?fila 1) (- ?columna 1) ))
)


;;;;;Ejercicio 2:Crear reglas para que el sistema deduzca (y mantenga) donde caería una ficha si se juega en la columna c
;primera ficha de la columna
(defrule cae_ini
    (Tablero ?t 6 ?columna _) ;columna vacia
    =>
    (assert (cae 6 ?columna))
)

;actualiza el "cae" cuando se ocupa la posicion (sube una fila)
(defrule cae
    ?r <- (cae ?fila ?columna)
    (Tablero ?t ?fila ?columna ?j)
    (test (neq ?j _)) ;no vacio
    (test (> ?fila 1)) ;fila mayor que 1, dentro del tablero
    =>
    (retract ?r)
    (assert (cae (- ?fila 1) ?columna)) ;una fila mas arriba
)

;se quita cuando la columna este llena
(defrule deshacer_cae ;si esta llena el hueco no existe
    ?r <- (cae ?fila ?columna)
    (Tablero ?t ?fila ?columna M|J)
    (test (eq ?fila 1))
    =>
    (retract ?r)
)


;;;;;Ejercicio 3:Crear reglas para que el sistema deduzca que hay dos fichas de un mismo jugador en línea en una dirección y posiciones concretas
(defrule dos_fichas_en_linea
    (Tablero ?t ?fila1 ?columna1 ?j)
    (Tablero ?t ?fila2 ?columna2 ?j)
    (test (neq ?j _)) ;que no sea vacio, claro
    (siguiente ?fila1 ?columna1 ?direccion ?fila2 ?columna2)
    =>
    (assert (conectado ?t ?direccion ?fila1 ?columna1 ?fila2 ?columna2 ?j))
)

;para anterior en vez de siguiente
(defrule dos_fichas_en_linea_v2
    (Tablero ?t ?fila1 ?columna1 ?j)
    (Tablero ?t ?fila2 ?columna2 ?j)
    (test (neq ?j _)) ;que no sea vacio, claro
    (anterior ?fila1 ?columna1 ?direccion ?fila2 ?columna2)
    =>
    (assert (conectadov2 ?t ?direccion ?fila1 ?columna1 ?fila2 ?columna2 ?j))
)


;;;;;Ejercicio 4:Crear reglas para deducir que un jugador tiene 3 en línea en una dirección y posiciones concretas
;;basicamente utilizamos el ejercicio anterior pero pedimos que haya una fichas mas
(defrule tres_fichas_en_linea
    (conectado ?t ?direccion ?fila1 ?columna1 ?fila2 ?columna2 ?j)
    (siguiente ?fila2 ?columna2 ?direccion ?fila3 ?columna3)
    (Tablero ?t ?fila3 ?columna3 ?j) ;que sea del mismo jugador
    =>
    (assert (3_en_linea ?t ?direccion ?fila1 ?columna1 ?fila3 ?columna3 ?j)) ;3 en linea del jugador j empezando en (fila1,columna1), acabando en (fila3,columna3) en una direccion 
)

;para anterior en vez de siguiente (creo que no haria falta)
(defrule tres_fichas_en_linea_v2
    (conectadov2 ?t ?direccion ?fila1 ?columna1 ?fila2 ?columna2 ?j)
    (anterior ?fila2 ?columna2 ?direccion ?fila3 ?columna3)
    (Tablero ?t ?fila3 ?columna3 ?j) ;que sea del mismo jugador
    =>
    (assert (3_en_linea_v2 ?t ?direccion ?fila1 ?columna1 ?fila3 ?columna3 ?j)) ;3 en linea del jugador j empezando en (fila1,columna1), acabando en (fila3,columna3) en una direccion 
)


;;;;;Ejercicio 5: Añadir reglas para que el sistema deduzca (y mantenga) que un jugador ganaría si jugase en una columna
(defrule jugada_ganadora ;hay que ver que haya tres en linea de un mismo jugador y que se pueda ocupar la siguiente casilla
    (3_en_linea ?t ?direccion ?fila1 ?columna1 ?fila3 ?columna3 ?j) ;lo del anterior ejercicio
    (siguiente ?fila3 ?columna3 ?direccion ?fila4 ?columna4)
    (cae ?fila4 ?columna4)
    =>
    (assert (ganaria ?t ?j ?fila4 ?columna4))
)

;igual que la anterior regla pero cambiando siguiente por anterior (creo que no haria falta)
(defrule jugada_ganadora_v2 ;hay que ver que haya tres en linea de un mismo jugador y que se pueda ocupar la anterior casilla
    (3_en_linea_v2 ?t ?direccion ?fila1 ?columna1 ?fila3 ?columna3 ?j) ;lo del anterior ejercicio
    (anterior ?fila3 ?columna3 ?direccion ?fila4 ?columna4)
    (cae ?fila4 ?columna4)
    =>
    (assert (ganaria ?t ?j ?fila4 ?columna4))
)

;;;;;Ahora hagamos que si hay jugada ganadora, la maquina tire en esa columna su ficha:
(defrule jugar_a_ganar
    (declare (salience -10))
    (ganaria ?t M ?fila4 ?columna4)
    (Turno M)
    =>
    (printout t "Estoy jugando a jugar_a_ganar" crlf)
    (assert (Juega M ?columna4))
)

;;;;;Hagamos que si no podemos ganar en el turno, al menos no perdamos:
(defrule jugar_a_no_perder
    (declare (salience -11))
    (ganaria ?t J ?fila4 ?columna4)
    (Turno M)
    =>
    (printout t "Estoy jugando a jugar_a_no_perder" crlf)
    (assert (Juega M ?columna4))
)

;;;;;Si no se da ninguna de las dos situaciones anteriores, si tenemos ya 2 en linea jugamos para hacer la tercera ficha seguida
(defrule jugar_tercera_ficha
    (declare (salience -12))
    (conectado ?t ?direccion ?fila1 ?columna1 ?fila2 ?columna2 M)
    (siguiente ?fila2 ?columna2 ?direccion ?fila3 ?columna3)
    (siguiente ?fila3 ?columna3 ?direccion ?fila4 ?columna4)
    (Tablero ?t ?fila4 ?columna4 _)
    (cae ?fila3 ?columna3)
    (Turno M)
    =>
    (printout t "Estoy jugando a jugar_tercera_ficha" crlf)
    (assert (Juega M ?columna3)) 
)

;caso en el que el hueco este en el medio
(defrule jugar_tercera_ficha_hueco_en_medio
    (declare (salience -12))
    (Tablero ?t ?fila1 ?columna1 ?j)
    (Tablero ?t ?fila2 ?columna2 _)
    (Tablero ?t ?fila3 ?columna3 ?j)
    (test (neq ?j _)) ;que no sea vacio, claro
    (siguiente ?fila1 ?columna1 ?direccion ?fila2 ?columna2)
    (siguiente ?fila2 ?columna2 ?direccion ?fila3 ?columna3)
    (cae ?fila2 ?columna2)
    (Turno M)
    =>
    (printout t "Estoy jugando a jugar_tercera_ficha_hueco_en_medio" crlf)
    (assert (Juega M ?columna2))
)

;;;;;;;;;;Si no se da ninguna de las tres situaciones anteriores, si el rival tiene 2 en linea jugamos para bloquearle
(defrule jugar_a_tapar_al_rival
    (declare (salience -13))
    (conectado ?t ?direccion ?fila1 ?columna1 ?fila2 ?columna2 J)
    (siguiente ?fila2 ?columna2 ?direccion ?fila3 ?columna3)
    (cae ?fila3 ?columna3)
    (Turno M)
    =>
    (printout t "Estoy jugando a jugar_a_tapar_al_rival" crlf)
    (assert (Juega M ?columna3)) 
)

;;;;;;;;Si no se da ninguna de las cuatro situaciones anteriores, buscamos una ficha nuestra para colocar otra nuestra en linea
(defrule jugar_segunda_ficha
    (declare (salience -14))
    (Tablero ?t ?fila1 ?columna1 M)
    (siguiente ?fila1 ?columna1 ?direccion ?fila2 ?columna2)
    (cae ?fila2 ?columna2)
    (Turno M)
    =>
    (printout t "Estoy jugando a jugar_segunda_ficha" crlf)
    (assert (Juega M ?columna2))    
)

;;caso mas dificil de ver: falta una ficha en el centro de las 4 en raya
(defrule jugada_ganadora_dificil
    (conectado ?t ?direccion ?fila1 ?columna1 ?fila2 ?columna2 ?j)
    (siguiente ?fila2 ?columna2 ?direccion ?fila3 ?columna3)
    (Tablero ?t ?fila3 ?columna3 _) ;que este vacio
    (siguiente ?fila3 ?columna3 ?direccion ?fila4 ?columna4)
    (Tablero ?t ?fila4 ?columna4 ?j)
    (cae ?fila3 ?columna3)
    =>
    (assert (ganaria ?t ?j ?fila3 ?columna3)) 
)

;;caso mas dificil de ver: falta una ficha en el centro de las 4 en raya. en este caso con ficha anterior
(defrule jugada_ganadora_dificil_v2
    (conectadov2 ?t ?direccion ?fila1 ?columna1 ?fila2 ?columna2 ?j)
    (anterior ?fila2 ?columna2 ?direccion ?fila3 ?columna3)
    (Tablero ?t ?fila3 ?columna3 _) ;que este vacio
    (anterior ?fila3 ?columna3 ?direccion ?fila4 ?columna4)
    (Tablero ?t ?fila4 ?columna4 ?j)
    (cae ?fila3 ?columna3)
    =>
    (assert (ganaria ?t ?j ?fila3 ?columna3)) 
)

;se actualiza el "ganaria" cuando ya han puesto una ficha en el hueco
(defrule ya_no_gana
   ?r <- (ganaria ?t ?j ?fila3 ?columna3)
   (not (cae ?fila3 ?columna3))
   =>
   (retract ?r)
)


;;;; Practica 4 Ingenieria del conocimiento ;;;;;;;
;;;; Alvaro Luna Ramirez, 4º DGIIM ;;;;;
;;;; Sistema experto: Tengo un viaje para usted;;;;;
;;;; Utilizar un sistema modular ;;;;;;

;;;;; El funcionamiento del sistema experto es el siguiente. Primero se realizan varias preguntas, en el orden que
;;;;; considero mas oportuno: empiezo por la duracion del viaje y el dinero dispuesto a gastar, que creo que es lo principal.
;;;;; despues seguire con el resto de preguntas (a no ser que alguna se considere innecesaria por alguna respuesta anterior: 
;;;;; por ejemplo si el dinero introducido es insuficiente no preguntare sobre ir al extranjero).
;;;;; Despues se van considerando oportunos los viajes segun combinen mejor con las respuestas dadas, dando algo mas
;;;;; de prioridad a las que dan mas beneficio a la agencia de viajes. Cuando oferta un viaje da los motivos por los que lo ha elegido.
;;;;; Si el cliente va rechazando los viajes el sistema va dando los que queden disponibles de los 10 que tiene. 
;;;;; Asi hasta que no quede ninguno o se haya aceptado algun viaje.   
;;;;; El programa esta dividido en dos modulos, uno para las preguntas y otro para la busqueda del viaje mas adecuado segun lo que se haya respondido.


;;;;; Para la práctica 4 añado un modulo mas, para llegar a los 3 en todo el programa (en la práctica 3 ya había implementado dos módulos)
;;;;; Los tres módulos son:
;;;;;     1. "Preg": Preguntas para adquirir los intereses del cliente
;;;;;     2. "Busq": Busqueda de viajes adecuados,  y aconseja los que considere oportunos
;;;;;     3. "Resp": Se responde a los consejos del sistema

;Hechos propuestos en el guion:
;(Adecuado <código del viaje> “<texto del motivo>”)
;(Ofertar <código del viaje>)
;(Rechazado <código del viaje> <motivo>)
;(Aceptado <código del viaje>)

;;los hechos relacionados con las posibles respuestas a las preguntas son los siguientes:
;Numero de dias:
;(RDuracion SEMANA | PUENTE | FINDE | NS)

;Tiempo:
;(RTiempo CALOR | FRIO | NS)

;Playa
;(respuesta playa SI | NO | NS)

;Naturaleza
;(respuesta naturaleza SI | NO | NS)

;Dinero maximo
;(RDinero NIVELUNO | NIVELDOS | NIVELTRES );;;;se ajustara segun el numero introducido;;;;;;;;;;;

;Avion
;(respuesta avion SI | NO | NS)

;Mucha gente
;(respuesta gente SI | NO | NS)

;Extranjero
;(respuesta extranjero SI | NO | NS)

;;;;;;;;;;;;;;;;;;;;;;;;COMIENZO DEL TEST;;;;;;;;;;;;;;;;;
;Introduccion:
(defrule comienzo
    (declare (salience 9999))
    =>    
    (printout t "Bienvenido! Tengo un viaje para usted! Voy a recomendarle el mejor viaje segun sus intereses." crlf)
    (printout t "Voy a realizar algunas preguntas para conocerle mejor. Entre parentesis le indicare las posibles respuestas. Si en algun momento le incomodo y desea parar con las preguntas, escriba BASTA." crlf)
    (printout t "Comencemos!" crlf)
    (focus Preguntas)
)

(defmodule Preguntas (export ?ALL))


;;;Template para representar los aspectos que nos interesan de los viajes de la base de datos
(deftemplate Viaje
    (slot codigo)
    (slot destino )
    (slot dia_salida)
    (slot transporte)
    (slot duracion) ;en dias
    (slot precio)
    (slot beneficio_agencia)
)
;;Añado los viajes que puse en la entrega del ejercicio de la rejilla (mas un par extra)
(deffacts viajes
    (Viaje (codigo V1) (destino Barcelona) (dia_salida Jueves) (transporte Avion) (duracion 4) (precio 800) (beneficio_agencia 15))
    (Viaje (codigo V2) (destino Madrid) (dia_salida Viernes) (transporte Avion) (duracion 3) (precio 400) (beneficio_agencia 20))
    (Viaje (codigo V3) (destino Cádiz) (dia_salida Sabado) (transporte Bus) (duracion 2) (precio 110) (beneficio_agencia 25))
    (Viaje (codigo V4) (destino Albarracín) (dia_salida Sabado) (transporte Bus) (duracion 1) (precio 30) (beneficio_agencia 30))
    (Viaje (codigo V5) (destino SanSebastián) (dia_salida Viernes) (transporte Avion) (duracion 3) (precio 300) (beneficio_agencia 35))
    (Viaje (codigo V6) (destino PicosdeEuropa) (dia_salida Jueves) (transporte Bus) (duracion 4) (precio 150) (beneficio_agencia 40))
    (Viaje (codigo V7) (destino Cáceres) (dia_salida Sabado) (transporte Bus) (duracion 2) (precio 175) (beneficio_agencia 45))
    (Viaje (codigo V8) (destino Granada) (dia_salida Viernes) (transporte Bus) (duracion 3) (precio 250) (beneficio_agencia 50))
    (Viaje (codigo V9) (destino Tenerife) (dia_salida Lunes) (transporte Avion) (duracion 7) (precio 1300) (beneficio_agencia 60))
    (Viaje (codigo V10) (destino Londres) (dia_salida Jueves) (transporte Avion) (duracion 4) (precio 1000) (beneficio_agencia 70))
)

;Pasamos las preguntas
; Hecho para representar las preguntas
(deffacts Preguntas
    (Modulo Preg)
    (pregunta naturaleza)
    (pregunta gente)        
    (pregunta extranjero)   ;solo se preguntara si no se ha introducido poco dinero (nivel 2 o 3) y si acepta el avion
    (pregunta playa)
    (pregunta avion)        ;solo se preguntara si no se ha introducido poco dinero (nivel 2 o 3)
    (pregunta tiempo)       
    (pregunta dinero)     
    (pregunta duracion)     
)

;;;;;;;;;;;;;;;;;;;;;;;pregunta sobre la naturaleza
(defrule pregnaturaleza
    (Modulo Preg)
    ?r <- (pregunta naturaleza)
    =>
    (retract ?r)
    (printout t "¿Le gusta la naturaleza? (Si | No | NS)" crlf)
    (assert (respuesta naturaleza (upcase (read))))
)

;;;;;;;;;;;;;;;;;;;;;;;pregunta sobre la gente
(defrule preggente
    (Modulo Preg)
    ?r <- (pregunta gente)
    =>
    (retract ?r)
    (printout t "¿Estaria dispuesto a viajar a un sitio en el que se pueda encontrar con grandes aglomeraciones? (Si | No | NS)" crlf)
    (assert (respuesta gente (upcase (read))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;pregunta sobre extranjero
(defrule pregextranjero
    (Modulo Preg)
    ?r <- (pregunta extranjero)
    (not(RDineroNivel NIVEL1)) ;solo los viajes de nivel 2 y 3 iran fuera de españa
    (respuesta avion SI)
    =>
    (retract ?r)
    (printout t "¿Estaria dispuesto a viajar al extranjero? (Si | No | NS)" crlf)
    (assert (respuesta extranjero (upcase (read))))
)

;;;;;;;;;;;;;;;;;;;;;;;pregunta sobre el avion
(defrule pregavion
    (Modulo Preg)
    ?r <- (pregunta avion)
    (not(RDineroNivel NIVEL1)) ;solo los viajes de nivel 2 y 3 tienen avion
    =>
    (retract ?r)
    (printout t "¿Estaria dispuesto a subirse a un avion? (Si | No | NS)" crlf)
    (assert (respuesta avion (upcase (read))))
)

;;;;;;;;;;;;;;;;;;;;;;;pregunta sobre la playa
(defrule pregplaya
    (Modulo Preg)
    ?r <- (pregunta playa)
    =>
    (retract ?r)
    (printout t "¿Le gusta la playa? (Si | No | NS)" crlf)
    (assert (respuesta playa (upcase (read))))
)

;;;;sirve para comprobar que la respuesta este bien en las preguntas con si o no como respuesta
(defrule respuestasino
    (declare (salience 999))
    (Modulo Preg)
    ?r <- (respuesta ?pregunta ?resp)
    (test
        (or
            (and
                (neq ?resp SI)
                (and
                    (neq ?resp NO)
                    (neq ?resp NS) 
                )
            )
            (neq (type ?resp) SYMBOL)
        )
    )
    =>
    (retract ?r)
    (printout t "No ha introducido una respuesta valida. Vuelva a intentarlo." crlf)
    (assert (pregunta ?pregunta))
)

(defrule comprobarBASTA3
    (declare (salience 9999))
    ?r <- (respuesta ?pregunta ?respuesta)
    (test (eq (type ?respuesta) SYMBOL))
    (test (eq (upcase ?respuesta) BASTA))
    =>
    (retract ?r)
    (printout t "De acuerdo, dejo de preguntar." crlf)
    (assert (RParar SI))
)

;;;;;;;;;;;;;;;;;;;;;;;pregunta sobre el dinero
(defrule pregdinero
    (Modulo Preg)
    ?r <- (pregunta dinero)
    =>
    (retract ?r)
    (printout t "¿Cuanto dinero estaria dispuesto a gastarse? (Introduzca un numero positivo)" crlf)
    (assert (RDinero (read)))
)

(defrule comprobarBASTA4
    (declare (salience 9999))
    ?r <- (RDinero ?respuesta)
    (test (eq (type ?respuesta) SYMBOL))
    (test (eq (upcase ?respuesta) BASTA))
    =>
    (retract ?r)
    (printout t "De acuerdo, dejo de preguntar.")
    (assert (RParar SI))
)

;;comprueba que sea un numero
(defrule respuestadinero1
    (declare (salience 999))
    (Modulo Preg)
    ?r <- (RDinero ?din)
    (test (neq (type ?din) INTEGER))
    (test (neq (type ?din) FLOAT))
    => 
    (retract ?r)
    (printout t "No ha introducido una respuesta valida. Vuelva a intentarlo." crlf)
    (assert (pregunta dinero))
)

;;comprueba que sea un numero mayor que 0
(defrule respuestadinero2
    (declare (salience 999))
    (Modulo Preg)
    ?r <- (RDinero ?din)
    (test
        (or 
            (eq (type ?din) INTEGER)
            (eq (type ?din) FLOAT)
        )
    )
    (test (< ?din 0.0))
    => 
    (retract ?r)
    (printout t "No ha introducido una respuesta valida. Vuelva a intentarlo." crlf)
    (assert (pregunta dinero))
)
;

;;;ahora clasificamos en niveles segun el dinero introducido
;nivel1:0-200
;nivel2:200-400
;nivel3:>400
(defrule respuestadineronivel1
    (declare (salience 998))
    (Modulo Preg)
    ?r <- (RDinero ?din)
    (test 
        (or 
            (eq (type ?din) INTEGER) 
            (eq (type ?din) FLOAT)
        )
    )
    (test 
        (and
            (> ?din 0.0)
            (<= ?din 200.0)
        )
    )
    =>
    (retract ?r)
    (assert (RDineroNivel NIVEL1))
)

(defrule respuestadineronivel2
    (declare (salience 998))
    (Modulo Preg)
    ?r <- (RDinero ?din)
    (test 
        (or 
            (eq (type ?din) INTEGER) 
            (eq (type ?din) FLOAT)
        )
    )
    (test 
        (and
            (> ?din 200.0)
            (<= ?din 400.0)
        )
    )
    =>
    (retract ?r)
    (assert (RDineroNivel NIVEL2))
)

(defrule respuestadineronivel3
    (declare (salience 998))
    (Modulo Preg)
    ?r <- (RDinero ?din)
    (test 
        (or 
            (eq (type ?din) INTEGER) 
            (eq (type ?din) FLOAT)
        )
    )
    (test (> ?din 400.0))
    =>
    (retract ?r)
    (assert (RDineroNivel NIVEL3))
)

;;;;;;;;;;;;;;;;;;;;;;;pregunta sobre el tiempo
(defrule pregtiempo
    (Modulo Preg)
    ?r <- (pregunta tiempo)
    =>
    (retract ?r)
    (printout t "¿Que tiempo le gusta? (Calor | Frio | NS)" crlf)
    (assert (RTiempo (upcase (read))))
)

;compruebo la respuesta
(defrule respuestaTiempo
    (declare (salience 999))
    (Modulo Preg)
    ?r <- (RTiempo ?tr)
    (test
        (and
            (neq ?tr CALOR)
            (and
                (neq ?tr FRIO)
                (neq ?tr NS)
            )
        )
    )
    =>
    (retract ?r)
    (printout t "No ha introducido una respuesta valida. Vuelva a intentarlo." crlf)
    (assert (pregunta tiempo))
)

(defrule comprobarBASTA2
    (declare (salience 9999))
    ?r <- (RTiempo ?respuesta)
    (test (eq (type ?respuesta) SYMBOL))
    (test (eq (upcase ?respuesta) BASTA))
    =>
    (retract ?r)
    (printout t "De acuerdo, dejo de preguntar." crlf)
    (assert (RParar SI))
)

;;;;;;;;;;;;;;;;;;;preguntar por la duracion del viaje
(defrule pregduracion
    (Modulo Preg)
    ?r <- (pregunta duracion)
    =>
    (retract ?r)
    (printout t "¿De cuanta duracion es el viaje que pensaba realizar? (Semana | Puente | Finde | NS)" crlf)
    (assert (RDuracion (upcase (read))))
)

;compruebo que la respuesta sea correcta
(defrule respuestaDuracion
    (declare (salience 999))
    (Modulo Preg)
    ?r <- (RDuracion ?tr)
    (test
        (and
            (neq ?tr SEMANA)
            (and
                (neq ?tr PUENTE)
                (and
                    (neq ?tr FINDE)
                    (neq ?tr NS)
                )
            )
        )
    )
    =>
    (retract ?r)
    (printout t "No ha introducido una respuesta valida. Vuelva a intentarlo." crlf)
    (assert (pregunta duracion))
)

;;;;miro si hay que parar
(defrule comprobarBASTA1
    (declare (salience 9999))
    ?r <- (RDuracion ?respuesta)
    (test (eq (type ?respuesta) SYMBOL))
    (test (eq (upcase ?respuesta) BASTA))
    =>
    (retract ?r)
    (printout t "De acuerdo, dejo de preguntar." crlf)
    (assert (RParar SI))
)

;;paro
(defrule parar
    (declare (salience 9999))
    ?m <- (Modulo Preg)
    (RParar SI)
    =>
    (retract ?m)
    (focus Busqueda)
    (assert (Modulo Busq))
)

;;para no preguntar por el avion o si se quiere ir a un pais extranjero en caso de que no haya dinero suficiente
(defrule inferir
    (declare (salience 9999))
    ?m <- (Modulo Preg)
    (not(RDineroNivel NIVEL3))
    =>
    (assert (respuesta avion NO))
    (assert (respuesta extranjero NO))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;fin de las preguntas
;se acaban las preguntas
(defrule finPreguntas1
    (declare (salience 300))
    ?m <- (Modulo Preg)
    (RDuracion ?rd)
    (RTiempo ?rt)
    (respuesta playa ?rp)
    (respuesta naturaleza ?rn)
    (RDineroNivel ?rn123)
    (respuesta avion ?ra)
    (respuesta gente ?rg)
    (respuesta extranjero ?re)
    =>
    (retract ?m)
    (focus Busqueda)
    (assert (Modulo Busq))
    (printout t "Pasa a buscar el viaje." crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;paso a la busqueda del viaje
(defmodule Busqueda (export ?ALL) (import Preguntas ?ALL))

;;;;;;;;;;;;;;;ACONSEJA VIAJES
(defrule aconsejaTenerife1 ;por duracion, tiempo , playa, dinero, avion
    (declare (salience 150)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (RDuracion SEMANA)
    (RTiempo CALOR)
    (respuesta playa SI)
    (RDineroNivel NIVEL3)
    (respuesta avion SI)
    (not (Rechazado V9 ?mot))
    =>
    (assert (Adecuado V9 "este viaje dura una semana, hara buen tiempo, tiene muchas playas, se adapta a su situacion economica y debe realizarse en avion." ))
)

(defrule aconsejaLondres1 ;por duracion, tiempo , respuesta de extranjero y dinero
    (declare (salience 149)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (RDuracion PUENTE)
    (RTiempo FRIO)
    (respuesta extranjero SI)
    (RDineroNivel NIVEL3)
    (respuesta avion SI)
    (not (Rechazado V10 ?mot))
    =>
    (assert (Adecuado V10 "este viaje es adecuado para un puente, hara frio, hay que ir al extranjero, se adapta a su situacion economica y debe viajar en avion." ))
)

(defrule aconsejaGranada1
    (declare (salience 148)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (not (RDuracion SEMANA))
    (RTiempo CALOR)
    (not (RDineroNivel NIVEL3))
    (not (Rechazado V8 ?mot))
    (respuesta naturaleza SI)
    =>
    (assert (Adecuado V8 "este viaje es adecuado para un fin de semana o un puente, hara calor, es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaCaceres1
    (declare (salience 147)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (RDuracion FINDE)
    (RTiempo CALOR)
    (RDineroNivel NIVEL1)
    (not (Rechazado V7 ?mot))
    =>
    (assert (Adecuado V7 "este viaje es adecuado para un fin de semana, hara calor y se adapta a su situacion economica." ))
)

(defrule aconsejaPicosdeEuropa1
    (declare (salience 146)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (not (RDuracion SEMANA))
    (RDineroNivel NIVEL1)
    (not (Rechazado V6 ?mot))
    (respuesta naturaleza SI)
    (respuesta gente NO)
    =>
    (assert (Adecuado V6 "este viaje es adecuado para un puente, no habra grandes acumulaciones de gente, es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaSanSebastian1 
    (declare (salience 145)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (not (RDuracion SEMANA))
    (RTiempo FRIO)
    (respuesta playa SI)
    (RDineroNivel NIVEL3)
    (respuesta avion SI)
    (not (Rechazado V5 ?mot))
    =>
    (assert (Adecuado V5 "este viaje es adecuado para un puente o un fin de semana, hara fresco, tiene mucha playa, se adapta a su situacion economica y debe realizarse en avion." ))
)

(defrule aconsejaAlbarracin1
    (declare (salience 144)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (RDuracion FINDE)
    (RDineroNivel NIVEL1)
    (not (Rechazado V4 ?mot))
    (respuesta naturaleza SI)
    (respuesta gente NO)
    =>
    (assert (Adecuado V4 "este viaje es adecuado para un finde, no habra grandes acumulaciones de gente, es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaCadiz1
    (declare (salience 143)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (RDuracion FINDE)
    (RDineroNivel NIVEL1)
    (not (Rechazado V3 ?mot))
    (respuesta playa SI)
    =>
    (assert (Adecuado V3 "este viaje es adecuado para un finde, habra bastantes playas y se adapta a su situacion economica." ))
)

(defrule aconsejaMadrid1
    (declare (salience 142)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (not (RDuracion SEMANA))
    (not (RDineroNivel NIVEL1))
    (not (Rechazado V2 ?mot))
    (respuesta gente SI)
    =>
    (assert (Adecuado V2 "este viaje es adecuado para un puente o un finde, habra bastantes acumulaciones de gente y se adapta a su situacion economica." ))
)

(defrule aconsejaBarcelona1
    (declare (salience 141)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (RDuracion PUENTE)
    (RDineroNivel NIVEL3)
    (not (Rechazado V1 ?mot))
    (respuesta gente SI)
    (respuesta playa SI)
    =>
    (assert (Adecuado V1 "este viaje es adecuado para un puente, habra bastantes acumulaciones de gente, hay playas y se adapta a su situacion economica." ))
)

(defrule aconsejaTenerife2
    (declare (salience 140)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (RDuracion SEMANA)
    (respuesta playa SI)
    (RDineroNivel NIVEL3)
    (respuesta avion SI)
    (not (Rechazado V9 ?mot))
    =>
    (assert (Adecuado V9 "este viaje dura una semana, tiene muchas playas, se adapta a su situacion economica y debe realizarse en avion." ))
)

(defrule aconsejaTenerife3
    (declare (salience 130)) 
    (Modulo Busq)
    (RDuracion SEMANA)
    (respuesta playa SI)
    (RDineroNivel NIVEL3)
    (not (Rechazado V9 ?mot))
    =>
    (assert (Adecuado V9 "este viaje dura una semana, tiene muchas playas y se adapta a su situacion economica." ))
)

(defrule aconsejaTenerife4
    (declare (salience 120)) 
    (Modulo Busq)
    (RDuracion SEMANA)
    (RDineroNivel NIVEL3)
    (not (Rechazado V9 ?mot))
    =>
    (assert (Adecuado V9 "este viaje dura una semana y se adapta a su situacion economica." ))
)

(defrule aconsejaTenerife5
    (declare (salience 110))
    (Modulo Busq)
    (RDineroNivel NIVEL3)
    (not (Rechazado V9 ?mot))
    =>
    (assert (Adecuado V9 "se adapta a su situacion economica." ))
)

(defrule aconsejaTenerife6
    (declare (salience 100))
    (Modulo Busq)
    (not (Rechazado V9 ?mot))
    (or (RDuracion SEMANA)
        (RTiempo CALOR)
        (respuesta playa SI)
        (RDineroNivel NIVEL3)
        (respuesta avion SI))
    =>
    (assert (Adecuado V9 "concuerda con alguna de las respuestas introducidas." ))
)

(defrule aconsejaTenerife7
    (declare (salience 90))
    (Modulo Busq)
    (not (Rechazado V9 ?mot))
    =>
    (assert (Adecuado V9 "no nos quedan muchas mas opciones..." ))
)

(defrule aconsejaLondres2
    (declare (salience 139))
    (Modulo Busq)
    (RTiempo FRIO)
    (respuesta extranjero SI)
    (RDineroNivel NIVEL3)
    (respuesta avion SI)
    (not (Rechazado V10 ?mot))
    =>
    (assert (Adecuado V10 "hara frio, hay que ir al extranjero, se adapta a su situacion economica y debe viajar en avion." ))
)

(defrule aconsejaLondres3
    (declare (salience 129))
    (Modulo Busq)
    (RTiempo FRIO)
    (respuesta extranjero SI)
    (RDineroNivel NIVEL3)
    (not (Rechazado V10 ?mot))
    =>
    (assert (Adecuado V10 "hara frio, hay que ir al extranjero y se adapta a su situacion economica." ))
)

(defrule aconsejaLondres4
    (declare (salience 119))
    (Modulo Busq)
    (respuesta extranjero SI)
    (RDineroNivel NIVEL3)
    (not (Rechazado V10 ?mot))
    =>
    (assert (Adecuado V10 "hay que ir al extranjero y se adapta a su situacion economica." ))
)

(defrule aconsejaLondres5
    (declare (salience 109))
    (Modulo Busq)
    (RDineroNivel NIVEL3)
    (not (Rechazado V10 ?mot))
    =>
    (assert (Adecuado V10 "e adapta a su situacion economica." ))
)

(defrule aconsejaLondres6
    (declare (salience 99))
    (Modulo Busq)
    (not (Rechazado V9 ?mot))
    (or (RDuracion PUENTE)
        (RTiempo FRIO)
        (respuesta extranjero SI)
        (RDineroNivel NIVEL3)
        (respuesta avion SI))
    =>
    (assert (Adecuado V9 "concuerda con alguna de las respuestas introducidas." ))
)

(defrule aconsejaLondres7
    (declare (salience 89))
    (Modulo Busq)
    (not (Rechazado V9 ?mot))
    =>
    (assert (Adecuado V9 "que no nos quedan muchas mas opciones..." ))
)

(defrule aconsejaGranada2
    (declare (salience 138))
    (Modulo Busq)
    (not (RDuracion SEMANA))
    (RTiempo CALOR)
    (not (Rechazado V8 ?mot))
    (respuesta naturaleza SI)
    =>
    (assert (Adecuado V8 "este viaje es adecuado para un fin de semana o un puente, hara calor, es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaGranada3
    (declare (salience 128))
    (Modulo Busq)
    (not (RDuracion SEMANA))
    (RTiempo CALOR)
    (not (Rechazado V8 ?mot))
    =>
    (assert (Adecuado V8 "este viaje es adecuado para un fin de semana o un puente, hara calor y se adapta a su situacion economica." ))
)

(defrule aconsejaGranada4
    (declare (salience 98))
    (Modulo Busq)
    (not (Rechazado V8 ?mot))
    (or (not (RDuracion SEMANA))
        (RTiempo CALOR)
        (not (RDineroNivel NIVEL3))
        (respuesta naturaleza SI))
    =>
    (assert (Adecuado V8 "concuerda con alguna de las respuestas introducidas." ))
)

(defrule aconsejaGranada5
    (declare (salience 88))
    (Modulo Busq)
    (not (Rechazado V8 ?mot))
    =>
    (assert (Adecuado V8 "no nos quedan muchas opciones..." ))
)

(defrule aconsejaCaceres2
    (declare (salience 137))
    (Modulo Busq)
    (RDuracion FINDE)
    (RDineroNivel NIVEL1)
    (not (Rechazado V7 ?mot))
    =>
    (assert (Adecuado V7 "este viaje es adecuado para un fin de semana y se adapta a su situacion economica." ))
)

(defrule aconsejaCaceres3
    (declare (salience 127))
    (Modulo Busq)
    (RDuracion FINDE)
    (not (Rechazado V7 ?mot))
    =>
    (assert (Adecuado V7 "este viaje es adecuado para un fin de semana." ))
)

(defrule aconsejaCaceres4
    (declare (salience 97))
    (Modulo Busq)
    (not (Rechazado V7 ?mot))
    (or (RDuracion FINDE)
        (RTiempo CALOR)
        (RDineroNivel NIVEL1))
    =>
    (assert (Adecuado V7 "concuerda con alguna de las respuestas introducidas." ))
)

(defrule aconsejaCaceres5
    (declare (salience 87))
    (Modulo Busq)
    (not (Rechazado V7 ?mot))
    =>
    (assert (Adecuado V7 "no nos quedan muchas opciones..." ))
)

(defrule aconsejaPicosdeEuropa2
    (declare (salience 136))
    (Modulo Busq)
    (RDineroNivel NIVEL1)
    (not (Rechazado V6 ?mot))
    (respuesta naturaleza SI)
    (respuesta gente NO)
    =>
    (assert (Adecuado V6 " no habra grandes acumulaciones de gente, es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaPicosdeEuropa3
    (declare (salience 126))
    (Modulo Busq)
    (not (Rechazado V6 ?mot))
    (respuesta naturaleza SI)
    (respuesta gente NO)
    =>
    (assert (Adecuado V6 " no habra grandes acumulaciones de gente, es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaPicosdeEuropa4
    (declare (salience 116))
    (Modulo Busq)
    (not (Rechazado V6 ?mot))
    (respuesta naturaleza SI)
    =>
    (assert (Adecuado V6 " es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaPicosdeEuropa4
    (declare (salience 96))
    (Modulo Busq)
    (not (Rechazado V6 ?mot))
    (or (not (RDuracion SEMANA))
        (RDineroNivel NIVEL1)
        (respuesta naturaleza SI)
        (respuesta gente NO))
    =>
    (assert (Adecuado V6 " se adapta a su situacion economica." ))
)

(defrule aconsejaPicosdeEuropa5
    (declare (salience 86))
    (Modulo Busq)
    (not (Rechazado V6 ?mot))
    =>
    (assert (Adecuado V6 " se adapta a su situacion economica." ))
)

(defrule aconsejaSanSebastian2
    (declare (salience 135))
    (Modulo Busq)
    (not (RDuracion SEMANA))
    (respuesta playa SI)
    (RDineroNivel NIVEL3)
    (respuesta avion SI)
    (not (Rechazado V5 ?mot))
    =>
    (assert (Adecuado V5 "este viaje es adecuado para un puente o un fin de semana, tiene mucha playa, se adapta a su situacion economica y debe realizarse en avion." ))
)

(defrule aconsejaSanSebastian3
    (declare (salience 125))
    (Modulo Busq)
    (respuesta playa SI)
    (RDineroNivel NIVEL3)
    (respuesta avion SI)
    (not (Rechazado V5 ?mot))
    =>
    (assert (Adecuado V5 "tiene mucha playa, se adapta a su situacion economica y debe realizarse en avion." ))
)

(defrule aconsejaSanSebastian4
    (declare (salience 105))
    (Modulo Busq)
    (RDineroNivel NIVEL3)
    (not (Rechazado V5 ?mot))
    =>
    (assert (Adecuado V5 " se adapta a su situacion economica" ))
)

(defrule aconsejaSanSebastian5
    (declare (salience 95))
    (Modulo Busq)
    (not (Rechazado V5 ?mot))
    (or (not (RDuracion SEMANA))
        (RTiempo FRIO)
        (respuesta playa SI)
        (RDineroNivel NIVEL3)
        (respuesta avion SI))
    =>
    (assert (Adecuado V5 "concuerda con alguna de las respuestas introducidas." ))
)

(defrule aconsejaSanSebastian6
    (declare (salience 85))
    (Modulo Busq)
    (not (Rechazado V5 ?mot))
    =>
    (assert (Adecuado V5 "no nos quedan muchas opciones..." ))
)

(defrule aconsejaAlbarracin2
    (declare (salience 134))
    (Modulo Busq)
    (RDuracion FINDE)
    (not (Rechazado V4 ?mot))
    (respuesta naturaleza SI)
    (respuesta gente NO)
    =>
    (assert (Adecuado V4 "este viaje es adecuado para un finde, no habra grandes acumulaciones de gente, es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaAlbarracin3
    (declare (salience 124))
    (Modulo Busq)
    (not (Rechazado V4 ?mot))
    (respuesta naturaleza SI)
    (respuesta gente NO)
    =>
    (assert (Adecuado V4 "no habra grandes acumulaciones de gente, es adecuado para amantes de la naturaleza y se adapta a su situacion economica." ))
)

(defrule aconsejaAlbarracin4
    (declare (salience 114))
    (Modulo Busq)
    (not (Rechazado V4 ?mot))
    (respuesta gente NO)
    =>
    (assert (Adecuado V4 "no habra grandes acumulaciones de gente y se adapta a su situacion economica." ))
)

(defrule aconsejaAlbarracin4
    (declare (salience 84))
    (Modulo Busq)
    (not (Rechazado V4 ?mot))
    =>
    (assert (Adecuado V4 "se adapta a su situacion economica..." ))
)

(defrule aconsejaCadiz2
    (declare (salience 133))
    (Modulo Busq)
    (RDuracion FINDE)
    (not (Rechazado V3 ?mot))
    (respuesta playa SI)
    =>
    (assert (Adecuado V3 "este viaje es adecuado para un finde, habra bastantes playas y se adapta a su situacion economica." ))
)

(defrule aconsejaCadiz3
    (declare (salience 123))
    (Modulo Busq)
    (not (Rechazado V3 ?mot))
    (respuesta playa SI)
    =>
    (assert (Adecuado V3 "habra bastantes playas y se adapta a su situacion economica." ))
)

(defrule aconsejaCadiz4
    (declare (salience 83))
    (Modulo Busq)
    (not (Rechazado V3 ?mot))
    =>
    (assert (Adecuado V3 "no nos quedan apenas opciones.." ))
)

(defrule aconsejaMadrid2
    (declare (salience 132)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (not (RDuracion SEMANA))
    (not (RDineroNivel NIVEL1))
    (not (Rechazado V2 ?mot))
    =>
    (assert (Adecuado V2 "este viaje es adecuado para un puente o un finde, y se adapta a su situacion economica." ))
)

(defrule aconsejaMadrid2
    (declare (salience 132)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (not (RDineroNivel NIVEL1))
    (not (Rechazado V2 ?mot))
    =>
    (assert (Adecuado V2 "se adapta a su situacion economica." ))
)

(defrule aconsejaMadrid3
    (declare (salience 92)) 
    (Modulo Busq)
    (not (Rechazado V2 ?mot))
    (or (not (RDuracion SEMANA))
        (not (RDineroNivel NIVEL1))
        (respuesta gente SI))
    =>
    (assert (Adecuado V2 "concuerda con alguna de las respuestas introducidas." ))
)

(defrule aconsejaMadrid4
    (declare (salience 82)) 
    (Modulo Busq)
    (not (Rechazado V2 ?mot))
    =>
    (assert (Adecuado V2 "no nos quedan apenas opciones..." ))
)

(defrule aconsejaBarcelona2
    (declare (salience 131)) ;preferencia segun los beneficios que de a la agencia
    (Modulo Busq)
    (RDuracion PUENTE)
    (RDineroNivel NIVEL3)
    (not (Rechazado V1 ?mot))
    (respuesta playa SI)
    =>
    (assert (Adecuado V1 "este viaje es adecuado para un puente, hay playas y se adapta a su situacion economica." ))
)

(defrule aconsejaBarcelona3
    (declare (salience 121)) 
    (Modulo Busq)
    (RDineroNivel NIVEL3)
    (not (Rechazado V1 ?mot))
    (respuesta playa SI)
    =>
    (assert (Adecuado V1 " hay playas y se adapta a su situacion economica." ))
)

(defrule aconsejaBarcelona4
    (declare (salience 111)) 
    (Modulo Busq)
    (RDineroNivel NIVEL3)
    (not (Rechazado V1 ?mot))
    =>
    (assert (Adecuado V1 "se adapta a su situacion economica." ))
)

(defrule aconsejaBarcelona5
    (declare (salience 91))
    (Modulo Busq)
    (not (Rechazado V1 ?mot))
    (or (RDuracion PUENTE)
        (RDineroNivel NIVEL3)
        (respuesta gente SI)
        (respuesta playa SI))
    =>
    (assert (Adecuado V1 "no nos quedan casi opciones..." ))
)

(defrule aconsejaBarcelona6
    (declare (salience 81))
    (Modulo Busq)
    (not (Rechazado V1 ?mot))
    =>
    (assert (Adecuado V1 "no nos quedan mas opciones." ))
)

(defrule aconseja
    (declare (salience 9999))
    ?f <- (Modulo Busq)
    (Viaje (codigo ?v) (destino ?dest) (dia_salida ?ds) (transporte ?t) (duracion ?d) (precio ?pre) (beneficio_agencia ?ba))
    (Adecuado ?v ?explicacion)
    (not (Rechazado ?v ?mot))
    =>
    (retract ?f)
    (assert (Modulo Resp))
    (assert (Ofertar ?v))   
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;FINAL: SE OFERTAN VIAJES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Pasar a ofertar
;modulo preg:

(defrule ofertar
    (declare (salience 9999))
    (Modulo Resp)
    ?r <- (Ofertar ?v)
    (Adecuado ?v ?explicacion)
    (not (Roferta ?v2 SI))
    (Viaje (codigo ?v) (destino ?dest) (dia_salida ?ds) (transporte ?t) (duracion ?d) (precio ?pre) (beneficio_agencia ?ba))
    =>
    (retract ?r)
    (printout t "El consejo del experto es un viaje con destino " ?dest ", de duracion " ?d "dias, por un precio de " ?pre " euros y con metodo de transporte " ?t ". Los motivos de la recomendacion son que " ?explicacion crlf)
    (printout t "Acepta el viaje? (Si | No)" crlf)
    (assert (Roferta ?v (upcase (read))))
)

(defrule respuestasinofinal
    (declare (salience 9999))
    (Modulo Resp)
    ?r <- (Roferta ?v ?resp)
    (test
        (or
            (and
                (neq ?resp SI)
                (neq ?resp NO)
            )
            (neq (type ?resp) SYMBOL)
        )
    )
    =>
    (retract ?r)
    (printout t "No ha introducido una respuesta valida. Vuelva a intentarlo." crlf)
    (assert (Ofertar ?v))
)

(defrule aceptar
    (declare (salience 9999))
    (Modulo Resp)
    (Roferta ?v SI)
    (Viaje (codigo ?v) (destino ?dest) (dia_salida ?ds) (transporte ?t) (duracion ?d) (precio ?pre) (beneficio_agencia ?ba))
    =>
    (printout t "Ya tiene su viaje!" crlf)
    (assert (Aceptado ?v))
)

(defrule rechazar
    (declare (salience 9999))
    ?f <- (Modulo Resp)
    (Roferta ?v NO)
    (not (Aceptado ?v_))
    =>
    (retract ?f)
    (assert (Modulo Busq))
    (printout t "Ha rechazado el viaje! ¿Cual es el motivo?" crlf)
    (assert (Rechazado ?v (upcase (read))))
)

(defrule sinviajes
    (declare (salience 9999)) 
    (Modulo Busq)
    (Rechazado V1 ?mot1)
    (Rechazado V2 ?mot2)
    (Rechazado V3 ?mot3)
    (Rechazado V4 ?mot4)
    (Rechazado V5 ?mot5)
    (Rechazado V6 ?mot6)
    (Rechazado V7 ?mot7)
    (Rechazado V8 ?mot8)
    (Rechazado V9 ?mot9)
    (Rechazado V10 ?mot10)
    =>
    (printout t "Lo sentimos, no nos quedan viajes..." crlf)
)

(defrule final1
    (declare (salience 9999))
    (Modulo Resp)
    (Aceptado ?v)
    =>
    (printout t "Gracias por confiar en nosotros!" crlf)
    (printout t "Hasta pronto!" crlf)
)

(defrule final2
    (declare (salience 9999))
    (Modulo Busq)
    (Aceptado ?v)
    =>
    (printout t "Gracias por confiar en nosotros!" crlf)
    (printout t "Hasta pronto!" crlf)
)



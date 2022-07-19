(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun X () Int)
(declare-fun Y () Int)

(assert (= (str.++ a b) (str.++ b a)))
(assert (str.contains a "x"))
(assert (str.contains b "y"))

(assert (= (str.len a) X))
(assert (= (str.len b) Y))

(assert (<= X 4))
(assert (<= Y 4))

; then the lengths of a, b cannot be coprime

(assert (not (and (and (and (and (and (and (and (and (and (and (and (and (or (not (= Y 10)) (and (and (<= 0 (+ 10 (* (- 1) X))) (<= 0 X)) (or (or (exists ((var0 Int)) (= X (* (- 10) var0))) (exists ((var0 Int)) (= X (* (- 5) var0)))) (exists ((var0 Int)) (= X (* (- 2) var0)))))) (or (not (= Y 9)) (and (and (<= 0 (+ 9 (* (- 1) X))) (<= 0 X)) (or (exists ((var0 Int)) (= X (* (- 9) var0))) (exists ((var0 Int)) (= X (* (- 3) var0))))))) (or (not (= Y 8)) (and (and (<= 0 (+ 10 (* (- 1) X))) (<= 0 X)) (and (or (<= 0 (+ (- 9) X)) (or (or (exists ((var0 Int)) (= X (* (- 8) var0))) (exists ((var0 Int)) (= X (* (- 4) var0)))) (exists ((var0 Int)) (= X (* (- 2) var0))))) (or (<= 0 (+ 8 (* (- 1) X))) (exists ((var0 Int)) (= X (* (- 2) var0)))))))) (or (not (= Y 7)) (and (and (<= 0 (+ 7 (* (- 1) X))) (<= 0 X)) (exists ((var0 Int)) (= X (* (- 7) var0)))))) (or (not (= Y 6)) (and (and (<= 0 (+ 10 (* (- 1) X))) (<= 0 X)) (and (or (or (<= 0 (+ (- 10) X)) (<= 0 (+ 6 (* (- 1) X)))) (or (exists ((var0 Int)) (= X (* (- 3) var0))) (exists ((var0 Int)) (= X (* (- 2) var0))))) (or (<= 0 (+ (- 7) X)) (or (or (exists ((var0 Int)) (= X (* (- 6) var0))) (exists ((var0 Int)) (= X (* (- 3) var0)))) (exists ((var0 Int)) (= X (* (- 2) var0))))))))) (or (not (= Y 5)) (and (and (<= 0 (+ 10 (* (- 1) X))) (<= 0 X)) (exists ((var0 Int)) (= X (* (- 5) var0)))))) (or (not (= Y 4)) (and (and (<= 0 (+ 10 (* (- 1) X))) (<= 0 X)) (and (or (<= 0 (+ (- 9) X)) (or (exists ((var0 Int)) (= X (* (- 4) var0))) (exists ((var0 Int)) (= X (* (- 2) var0))))) (or (<= 0 (+ 8 (* (- 1) X))) (exists ((var0 Int)) (= X (* (- 2) var0)))))))) (or (not (= Y 3)) (and (and (<= 0 (+ 9 (* (- 1) X))) (<= 0 X)) (exists ((var0 Int)) (= X (* (- 3) var0)))))) (or (not (= Y 2)) (and (and (<= 0 (+ 10 (* (- 1) X))) (<= 0 X)) (exists ((var0 Int)) (= X (* (- 2) var0)))))) (or (not (= Y 0)) (and (<= 0 (+ 10 (* (- 1) X))) (or (= X 0) (<= 0 (+ (- 2) X)))))) (or (or (or (or (or (or (or (or (or (or (= Y 10) (= Y 9)) (= Y 8)) (= Y 7)) (= Y 6)) (= Y 5)) (= Y 4)) (= Y 3)) (= Y 2)) (= Y 0)) (or (exists ((var0 Int)) (= Y (* (- 3) var0))) (exists ((var0 Int)) (= Y (* (- 2) var0)))))) (or (or (or (or (or (or (or (or (or (or (= Y 10) (= Y 9)) (= Y 8)) (= Y 7)) (= Y 6)) (= Y 5)) (= Y 4)) (= Y 3)) (= Y 2)) (= Y 0)) (exists ((var0 Int)) (= Y (* (- 2) var0))))) (or (or (or (or (or (or (or (or (or (= Y 10) (= Y 9)) (= Y 8)) (= Y 7)) (= Y 6)) (= Y 5)) (= Y 4)) (= Y 3)) (= Y 2)) (= Y 0)))))

;(assert (not (exists ((x Int))
;    (and (> x 1)
;         (exists ((y Int)) (= (str.len a) (* y x)))
;         (exists ((y Int)) (= (str.len b) (* y x)))))))

(check-sat)

(set-logic QF_S)

(declare-const x String)
(declare-const y String)

(assert (= y ((_ str.extract 1) x
              (re.++
                ((_ re.loop 2 3)
                 ((_ re.capture 1) (str.to.re "a")))
                re.all))))

(assert (str.in.re x (str.to.re "aabb")))
(assert (str.in.re y (str.to.re "a")))

(check-sat)
(get-model)

(set-logic QF_S)

(declare-const x String)
(declare-const y String)

; "aaaa".match(/(a*?){1,4}/) ===> a
(assert (= y ((_ str.extract 1) x
              (re.++
                (re.*? re.allchar)
                ((_ re.loop 1 4)
                 ((_ re.capture 1)
                  (re.*? (str.to.re "a"))))
                re.all))))

(assert (str.in.re x (str.to.re "aaaa")))
(assert (str.in.re y (str.to.re "a")))

(check-sat)
(get-model)

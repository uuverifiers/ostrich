(set-logic QF_S)

(declare-const w String)

(assert (not (and

        (= (str.in_re w (re.from_ecma2020 '((?=a*x)a)*x'))
           (str.in_re w (re.from_ecma2020 'a*x')))

; Currently takes a few seconds to solve ...
; and gives incorrect result?
;        (= (str.in_re w (re.from_ecma2020 '/(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/'))
;           (str.in_re w
;              (re.inter (re.from_ecma2020 '/.{6,}/')
;                        (re.from_ecma2020 '.*\d.*')
;                        (re.from_ecma2020 '.*[a-z].*')
;                        (re.from_ecma2020 '.*[A-Z].*'))))

 )))

(check-sat)

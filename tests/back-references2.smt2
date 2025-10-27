(declare-const w String)
(assert (str.contains w "AB"))
(assert (str.in_re w (re.++ ((_ re.capture 1) (re.range "A" "B")) (_ re.reference 1))))
(check-sat)
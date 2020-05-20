
(declare-const x String)

(assert (str.in.re x ((_ re.loop 0 100) (re.range "0" "9"))))
(assert (str.in.re x ((_ re.loop 100 200) (re.range "0" "9"))))

(assert (not (str.in.re x ((_ re.^ 100) (re.range "0" "9")))))

(check-sat)

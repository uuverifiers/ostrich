(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Za-z]{3,4}[0-9]{6}$
(assert (str.in_re X (re.++ ((_ re.loop 3 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; The company delivers cakes and also online send mothers  day flowers to Delhi.
(assert (not (str.in_re X (re.++ (str.to_re "The company delivers cakes and also online send mothers  day flowers to Delhi") re.allchar (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

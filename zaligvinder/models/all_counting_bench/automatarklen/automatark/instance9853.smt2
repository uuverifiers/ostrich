(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z1-9]{5}-[A-Z1-9]{5}-[A-Z1-9]{5}-[A-Z1-9]{5}-[A-Z1-9]{5}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "\u{0a}")))))
; /filename=p50[a-z0-9]{9}[0-9]{12}\.pdf/H
(assert (not (str.in_re X (re.++ (str.to_re "/filename=p50") ((_ re.loop 9 9) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re ".pdf/H\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

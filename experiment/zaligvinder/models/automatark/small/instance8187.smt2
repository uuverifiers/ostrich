(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((1[Zz]\d{16})|(\d{12})|([Tt]\d{10})|(\d{9}))$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "Z") (str.to_re "z")) ((_ re.loop 16 16) (re.range "0" "9"))) ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (re.union (str.to_re "T") (str.to_re "t")) ((_ re.loop 10 10) (re.range "0" "9"))) ((_ re.loop 9 9) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)

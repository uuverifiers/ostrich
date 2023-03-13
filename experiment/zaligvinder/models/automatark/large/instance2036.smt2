(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\w\W]{1,1500}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1500) (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]{4}\d{6}[a-zA-Z]{6}\d{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)

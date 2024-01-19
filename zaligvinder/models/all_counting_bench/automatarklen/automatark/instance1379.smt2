(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\/[a-zA-Z_-]+\.doc$/U
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re ".doc/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

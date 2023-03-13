(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-f0-9]{32}\/[a-f0-9]{32}\u{22}/R
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{22}/R\u{0a}"))))
(check-sat)

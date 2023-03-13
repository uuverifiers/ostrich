(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /i=[a-zA-Z0-9$~]{40}/U
(assert (str.in_re X (re.++ (str.to_re "/i=") ((_ re.loop 40 40) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "$") (str.to_re "~"))) (str.to_re "/U\u{0a}"))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Fsearchfast\x2FNavhelper
(assert (str.in_re X (str.to_re "/searchfast/Navhelper\u{0a}")))
; /filename=p50[a-z0-9]{9}[0-9]{12}\.pdf/H
(assert (str.in_re X (re.++ (str.to_re "/filename=p50") ((_ re.loop 9 9) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re ".pdf/H\u{0a}"))))
; (")([0-9]*)(",")([0-9]*)("\))
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22},\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22})\u{0a}"))))
(check-sat)

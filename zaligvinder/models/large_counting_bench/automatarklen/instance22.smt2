(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[\w-]{64}$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 64 64) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/U\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)

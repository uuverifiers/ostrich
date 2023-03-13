(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/3001[0-9A-F]{262,304}/
(assert (str.in_re X (re.++ (str.to_re "//3001") ((_ re.loop 262 304) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/\u{0a}"))))
(check-sat)

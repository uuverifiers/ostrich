(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/3\/[A-Z]{2}\/[a-f0-9]{32}\sHTTP/
(assert (not (str.in_re X (re.++ (str.to_re "//3/") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "HTTP/\u{0a}")))))
(check-sat)

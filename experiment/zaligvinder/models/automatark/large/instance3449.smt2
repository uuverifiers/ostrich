(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^GET\s\u{2f}[A-F0-9]{152}/m
(assert (not (str.in_re X (re.++ (str.to_re "/GET") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/") ((_ re.loop 152 152) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "/m\u{0a}")))))
(check-sat)

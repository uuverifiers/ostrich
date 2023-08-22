(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-z\s]{4,32})$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 32) (re.union (re.range "a" "z") (re.range "A" "z") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; [\u{00}-\x1F\x7F]
(assert (str.in_re X (re.++ (re.union (re.range "\u{00}" "\u{1f}") (str.to_re "\u{7f}")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

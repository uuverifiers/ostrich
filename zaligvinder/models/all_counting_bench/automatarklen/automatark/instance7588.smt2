(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((([sS][r-tR-Tx-zX-Z])\s*([sx-zSX-Z])?\s*([a-zA-Z]{2,3}))?\s*(\d\d)\s*-?\s*(\d{6,7}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "s") (re.range "x" "z") (str.to_re "S") (re.range "X" "Z"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re "s") (str.to_re "S")) (re.union (re.range "r" "t") (re.range "R" "T") (re.range "x" "z") (re.range "X" "Z")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 6 7) (re.range "0" "9")) (re.range "0" "9") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)

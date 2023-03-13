(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ".") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ".") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))))))
; ^(Op(.|us))(\s)[1-9](\d)*((,)?(\s)N(o.|um(.|ber))\s[1-9](\d)*)?$
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "1" "9") (re.* (re.range "0" "9")) (re.opt (re.++ (re.opt (str.to_re ",")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "N") (re.union (re.++ (str.to_re "o") re.allchar) (re.++ (str.to_re "um") (re.union re.allchar (str.to_re "ber")))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "1" "9") (re.* (re.range "0" "9")))) (str.to_re "\u{0a}Op") (re.union re.allchar (str.to_re "us"))))))
(check-sat)

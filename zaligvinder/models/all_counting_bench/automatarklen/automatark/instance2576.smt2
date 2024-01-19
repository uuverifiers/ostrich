(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((\d{1,5})*\.*(\d{0,3})"[W|D|H|DIA][X|\s]).*
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}") (re.* ((_ re.loop 1 5) (re.range "0" "9"))) (re.* (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re "\u{22}") (re.union (str.to_re "W") (str.to_re "|") (str.to_re "D") (str.to_re "H") (str.to_re "I") (str.to_re "A")) (re.union (str.to_re "X") (str.to_re "|") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))
(assert (> (str.len X) 10))
(check-sat)

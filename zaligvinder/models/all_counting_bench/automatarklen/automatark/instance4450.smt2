(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}dir([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.dir") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; Toolbar\s+\x2APORT3\x2A\d+Host\x3AconfigINTERNAL\.ini
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "*PORT3*") (re.+ (re.range "0" "9")) (str.to_re "Host:configINTERNAL.ini\u{0a}"))))
; ^((\d{1,3}(,\d{3})*)|(\d{1,3}))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

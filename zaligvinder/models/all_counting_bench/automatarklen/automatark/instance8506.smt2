(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
; ^(([0-9]|1[0-9]|2[0-4])(\.[0-9][0-9]?)?)$|([2][5](\.[0][0]?)?)$
(assert (str.in_re X (re.union (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) (re.opt (re.++ (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9"))))) (re.++ (str.to_re "\u{0a}25") (re.opt (re.++ (str.to_re ".0") (re.opt (str.to_re "0"))))))))
; \x5D\u{25}20\x5BPort_\d+TM_SEARCH3engineto=\x2Fezsb\s\x3A
(assert (str.in_re X (re.++ (str.to_re "]%20[Port_") (re.+ (re.range "0" "9")) (str.to_re "TM_SEARCH3engineto=/ezsb") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re ":\u{0a}"))))
; /\u{0d}\u{0a}Host\u{3a}\u{20}[^\u{0d}\u{0a}\u{2e}]+\u{2e}[^\u{0d}\u{0a}\u{2e}]+(\u{3a}\d{1,5})?\u{0d}\u{0a}\u{0d}\u{0a}$/H
(assert (not (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Host: ") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "."))) (str.to_re ".") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "."))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0d}\u{0a}\u{0d}\u{0a}/H\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

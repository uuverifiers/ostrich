(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-9]{5})*-([0-9]{4}))|([0-9]{5})$
(assert (str.in_re X (re.union (re.++ (re.* ((_ re.loop 5 5) (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; <!--[\\.|\\W|\\w]*?-->
(assert (str.in_re X (re.++ (str.to_re "<!--") (re.* (re.union (str.to_re "\u{5c}") (str.to_re ".") (str.to_re "|") (str.to_re "W") (str.to_re "w"))) (str.to_re "-->\u{0a}"))))
; /^connect\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/connect|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

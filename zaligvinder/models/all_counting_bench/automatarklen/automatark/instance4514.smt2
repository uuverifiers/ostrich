(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])(\s{0,1})([AM|PM|am|pm]{2,2})$)|(^([0-9]|[1][0-9]|[2][0-3])(\s{0,1})([AM|PM|am|pm]{2,2})$)
(assert (not (str.in_re X (re.union (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "M") (str.to_re "|") (str.to_re "P") (str.to_re "a") (str.to_re "m") (str.to_re "p"))) (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "M") (str.to_re "|") (str.to_re "P") (str.to_re "a") (str.to_re "m") (str.to_re "p"))))))))
; Ready\s+Eye.*http\x3A\x2F\x2Fsupremetoolbar
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Eye") (re.* re.allchar) (str.to_re "http://supremetoolbar\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

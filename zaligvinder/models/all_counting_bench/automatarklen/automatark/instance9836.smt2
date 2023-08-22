(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}[^\n\r]*A-311\s+lnzzlnbk\u{2f}pkrm\.finSubject\u{3a}Basic
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "A-311") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.finSubject:Basic\u{0a}"))))
; ^\.([rR]([aA][rR]|\d{2})|(\d{3})?)$
(assert (not (str.in_re X (re.++ (str.to_re ".") (re.union (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.union (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "r") (str.to_re "R"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Ready\s+Toolbar\d+ServerLiteToolbar
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "ServerLiteToolbar\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

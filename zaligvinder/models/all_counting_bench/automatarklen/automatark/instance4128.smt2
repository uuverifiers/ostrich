(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0][0-9]|[1][0-2])|[0-9]):([0-5][0-9])( *)((AM|PM)|(A|P))$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.* (str.to_re " ")) (re.union (str.to_re "AM") (str.to_re "PM") (str.to_re "A") (str.to_re "P")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; <title>(.*?)</title>
(assert (not (str.in_re X (re.++ (str.to_re "<title>") (re.* re.allchar) (str.to_re "</title>\u{0a}")))))
; ^\+[0-9]{1,3}\.[0-9]+\.[0-9]+$
(assert (not (str.in_re X (re.++ (str.to_re "+") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\u{3a}[^\n\r]*A-311\s+lnzzlnbk\u{2f}pkrm\.finSubject\u{3a}Basic
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "A-311") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.finSubject:Basic\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

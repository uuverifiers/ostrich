(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; hjhgquqssq\u{2f}pjm[^\n\r]*User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "hjhgquqssq/pjm") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}")))))
; (^[0][2][1579]{1})(\d{6,7}$)
(assert (str.in_re X (re.++ ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}02") ((_ re.loop 1 1) (re.union (str.to_re "1") (str.to_re "5") (str.to_re "7") (str.to_re "9"))))))
; logs\s+TCP.*Toolbarads\.grokads\.com
(assert (str.in_re X (re.++ (str.to_re "logs") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TCP") (re.* re.allchar) (str.to_re "Toolbarads.grokads.com\u{0a}"))))
; ^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w ]*.*))+\.(jpg|JPG)$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (re.++ (re.opt (str.to_re "$")) ((_ re.loop 2 2) (str.to_re "\u{5c}")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.+ (re.++ (str.to_re "\u{5c}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar))) (str.to_re ".") (re.union (str.to_re "jpg") (str.to_re "JPG")) (str.to_re "\u{0a}"))))
(check-sat)

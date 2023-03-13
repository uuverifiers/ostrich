(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\x3A.*www\x2Ewebcruiser\x2Ecc\w+www\x2Etopadwarereviews\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.* re.allchar) (str.to_re "www.webcruiser.cc") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.topadwarereviews.com\u{0a}")))))
; ^([0]?[1-9]|[1|2][0-9]|[3][0|1])[/]([0]?[1-9]|[1][0-2])[/]([0-9]{4}|[0-9]{2}) ([0-1][0-9]|[2][0-3]):([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re " ") (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; ^(\d?)*\.?(\d{1}|\d{2})?$
(assert (str.in_re X (re.++ (re.* (re.opt (re.range "0" "9"))) (re.opt (str.to_re ".")) (re.opt (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /PRIVMSG #new :\u{02}\u{5b}(GOOGLE|SCAN)\u{5d}\u{02}\u{20}Scanning/
(assert (not (str.in_re X (re.++ (str.to_re "/PRIVMSG #new :\u{02}[") (re.union (str.to_re "GOOGLE") (str.to_re "SCAN")) (str.to_re "]\u{02} Scanning/\u{0a}")))))
; WindowsFrom\x3A\x2FCU1\-extreme\x2Ebiz
(assert (str.in_re X (str.to_re "WindowsFrom:/CU1-extreme.biz\u{0a}")))
(check-sat)

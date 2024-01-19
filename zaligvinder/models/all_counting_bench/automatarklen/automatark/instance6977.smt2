(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\/install\.asp\?mac=[A-F\d]{12}\u{26}mode/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//install.asp?mac=") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "&mode/Ui\u{0a}")))))
; ^((0?[2])/(0?[1-9]|[1-2][0-9])|(0?[469]|11)/(0?[1-9]|[1-2][0-9]|30)|(0?[13578]|1[02])/(0?[1-9]|[1-2][0-9]|3[0-1]))/([1][9][0-9]{2}|[2-9][0-9]{3})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (str.to_re "30"))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))))) (str.to_re "/") (re.union (re.++ (str.to_re "19") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; url=http\x3A\s+jsp[^\n\r]*serverHOST\x3ASubject\x3Ai\-femdom\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "url=http:\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jsp") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "serverHOST:Subject:i-femdom.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

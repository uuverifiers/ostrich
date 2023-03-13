(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b[\w]+[\w.-][\w]+@[\w]+[\w.-]\.[\w]{2,4}\b
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^(([1-9]{1})|([0-1][1-2])|(0[1-9])|([1][0-2])):([0-5][0-9])(([aA])|([pP]))[mM]$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ (re.range "0" "1") (re.range "1" "2")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; ^(((0|((\+)?91(\-)?))|((\((\+)?91\)(\-)?)))?[7-9]\d{9})?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (re.union (re.++ (str.to_re "(") (re.opt (str.to_re "+")) (str.to_re "91)") (re.opt (str.to_re "-"))) (str.to_re "0") (re.++ (re.opt (str.to_re "+")) (str.to_re "91") (re.opt (str.to_re "-"))))) (re.range "7" "9") ((_ re.loop 9 9) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(4915[0-1]|491[0-4]\d|490\d\d|4[0-8]\d{3}|[1-3]\d{4}|[2-9]\d{3}|1[1-9]\d{2}|10[3-9]\d|102[4-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "4915") (re.range "0" "1")) (re.++ (str.to_re "491") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "490") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "4") (re.range "0" "8") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "3") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "10") (re.range "3" "9") (re.range "0" "9")) (re.++ (str.to_re "102") (re.range "4" "9"))) (str.to_re "\u{0a}"))))
; /\.php\?action=jv\&h=\d+/Ui
(assert (str.in_re X (re.++ (str.to_re "/.php?action=jv&h=") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
(check-sat)

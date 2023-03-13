(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}qt([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.qt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[5,6]\d{7}|^$
(assert (not (str.in_re X (re.union (re.++ (re.union (str.to_re "5") (str.to_re ",") (str.to_re "6")) ((_ re.loop 7 7) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /\/app\/\?prj=\d\u{26}pid=[^\r\n]+\u{26}mac=/Ui
(assert (str.in_re X (re.++ (str.to_re "//app/?prj=") (re.range "0" "9") (str.to_re "&pid=") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "&mac=/Ui\u{0a}"))))
; ^[+-]? *(\$)? *((\d+)|(\d{1,3})(\,\d{3})*)(\.\d{0,2})?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) (re.opt (str.to_re "$")) (re.* (str.to_re " ")) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)

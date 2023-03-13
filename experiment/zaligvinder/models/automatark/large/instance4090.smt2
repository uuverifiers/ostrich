(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /click.php\?c=\w{160}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/click") re.allchar (str.to_re "php?c=") ((_ re.loop 160 160) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/Ui\u{0a}")))))
; ^\({0,1}0(2|3|7|8)\){0,1}(\ |-){0,1}[0-9]{4}(\ |-){0,1}[0-9]{4}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "(")) (str.to_re "0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "7") (str.to_re "8")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/modules\/(n?\d|nu)\.swf$/U
(assert (not (str.in_re X (re.++ (str.to_re "//modules/") (re.union (re.++ (re.opt (str.to_re "n")) (re.range "0" "9")) (str.to_re "nu")) (str.to_re ".swf/U\u{0a}")))))
; ^([0-9]{2})(00[1-9]|0[1-9][0-9]|[1-2][0-9][0-9]|3[0-5][0-9]|36[0-6])$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "00") (re.range "1" "9")) (re.++ (str.to_re "0") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "36") (re.range "0" "6"))) (str.to_re "\u{0a}"))))
; ^(0{0,1}[1-9][0-9]){1}(\s){0,1}(\-){0,1}(\s){0,1}[1-9]{1}([0-9]{3}|[0-9]{4})(\-){0,1}(\s){0,1}[0-9]{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9") (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.range "1" "9")) (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)

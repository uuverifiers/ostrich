(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}\w+Pre\x2Fta\x2FNEWS\x2FKeyloggeradfsgecoiwnfhirmvtg\u{2f}ggqh\.kqh
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre/ta/NEWS/Keyloggeradfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}\u{0a}")))))
; ^([0]?[1-9]|[1][0-2])[./-]([0]?[1-9]|[1|2][0-9]|[3][0|1])[./-]([0-9]{4}|[0-9]{2})$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^((\+|00)[1-9]{1,3})?(\-| {0,1})?(([\d]{0,3})(\-| {0,1})?([\d]{5,11})){1}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "00")) ((_ re.loop 1 3) (re.range "1" "9")))) (re.opt (re.union (str.to_re "-") (re.opt (str.to_re " ")))) ((_ re.loop 1 1) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (re.opt (str.to_re " ")))) ((_ re.loop 5 11) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; [:]{1}[-~+o]?[)>]+
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re ":")) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.+ (re.union (str.to_re ")") (str.to_re ">"))) (str.to_re "\u{0a}")))))
; /&key=[a-z0-9]{32}&dummy=\d{3,5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/&key=") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "&dummy=") ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

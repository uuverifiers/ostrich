(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; gpstool\u{2e}globaladserver\u{2e}com\daction\x2E\w+data2\.activshopper\.com
(assert (not (str.in_re X (re.++ (str.to_re "gpstool.globaladserver.com") (re.range "0" "9") (str.to_re "action.") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "data2.activshopper.com\u{0a}")))))
; ^(\+|-)?(\d\.\d{1,6}|[1-8]\d\.\d{1,6}|90\.0{1,6})$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (re.range "1" "8") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "90.") ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}")))))
(check-sat)

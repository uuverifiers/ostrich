(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x7D\x7BSysuptime\x3A\d+\x2Fcommunicatortb
(assert (not (str.in_re X (re.++ (str.to_re "}{Sysuptime:") (re.+ (re.range "0" "9")) (str.to_re "/communicatortb\u{0a}")))))
; ^((\$?\-?)|(\-?\$?))([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)?(\.[0-9]*)?$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "$")) (re.opt (str.to_re "-"))) (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "$")))) (re.opt (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.* (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[a-z]{5,8}\d{2,3}\.xap\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".xap\u{0d}\u{0a}/Hm\u{0a}"))))
; RootviewNetControl\x2EServerdata2\.activshopper\.com
(assert (str.in_re X (str.to_re "RootviewNetControl.Server\u{13}data2.activshopper.com\u{0a}")))
(check-sat)

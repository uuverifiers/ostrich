(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((19|2\d)\d{2}\/(((0?[13578]|1[02])\/31)|((0?[1,3-9]|1[0-2])\/(29|30))))|((((19|2\d)(0[48]|[2468][048]|[13579][26])|(2[048]00)))\/0?2\/29)|((19|2\d)\d{2})\/((0?[1-9])|(1[0-2]))\/(0?[1-9]|1\d|2[0-8]))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/31")) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re ",") (re.range "3" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (str.to_re "29") (str.to_re "30"))))) (re.++ (re.union (re.++ (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6"))))) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8")) (str.to_re "00"))) (str.to_re "/") (re.opt (str.to_re "0")) (str.to_re "2/29")) (re.++ (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8"))) (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\u{2e}wpd([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.wpd") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /(\u{19}\u{00}|\u{00}\x5C)\u{00}n\u{00}w\u{00}d\u{00}b\u{00}l\u{00}i\u{00}b\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{19}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}n\u{00}w\u{00}d\u{00}b\u{00}l\u{00}i\u{00}b\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}"))))
; /filename\=\d+\.swf/H
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.+ (re.range "0" "9")) (str.to_re ".swf/H\u{0a}"))))
; www\x2Ezhongsou\x2Ecomclick\x2Edotcomtoolbar\x2Ecom
(assert (str.in_re X (str.to_re "www.zhongsou.comclick.dotcomtoolbar.com\u{0a}")))
(check-sat)

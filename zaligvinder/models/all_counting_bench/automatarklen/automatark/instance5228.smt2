(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}swf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.swf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(((19|2\d)\d{2}\/(((0?[13578]|1[02])\/31)|((0?[1,3-9]|1[0-2])\/(29|30))))|((((19|2\d)(0[48]|[2468][048]|[13579][26])|(2[048]00)))\/0?2\/29)|((19|2\d)\d{2})\/((0?[1-9])|(1[0-2]))\/(0?[1-9]|1\d|2[0-8]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/31")) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re ",") (re.range "3" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (str.to_re "29") (str.to_re "30"))))) (re.++ (re.union (re.++ (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6"))))) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8")) (str.to_re "00"))) (str.to_re "/") (re.opt (str.to_re "0")) (str.to_re "2/29")) (re.++ (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8"))) (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ver\d+sports\w+whenu\x2Ecomwp-includes\x2Ffeed\x2Ephp\x3F
(assert (str.in_re X (re.++ (str.to_re "ver") (re.+ (re.range "0" "9")) (str.to_re "sports") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "whenu.com\u{13}wp-includes/feed.php?\u{0a}"))))
; BasicPointsHost\x3Anews
(assert (not (str.in_re X (str.to_re "BasicPointsHost:news\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

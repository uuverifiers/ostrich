(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ShadowNet\s+AID\x2FUser-Agent\x3AFen\u{ea}treEye\x2Fdss\x2Fcc\.2_0_0\.
(assert (not (str.in_re X (re.++ (str.to_re "ShadowNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AID/User-Agent:Fen\u{ea}treEye/dss/cc.2_0_0.\u{0a}")))))
; ^(((19|2\d)\d{2}\/(((0?[13578]|1[02])\/31)|((0?[1,3-9]|1[0-2])\/(29|30))))|((((19|2\d)(0[48]|[2468][048]|[13579][26])|(2[048]00)))\/0?2\/29)|((19|2\d)\d{2})\/((0?[1-9])|(1[0-2]))\/(0?[1-9]|1\d|2[0-8]))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/31")) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re ",") (re.range "3" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (str.to_re "29") (str.to_re "30"))))) (re.++ (re.union (re.++ (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6"))))) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8")) (str.to_re "00"))) (str.to_re "/") (re.opt (str.to_re "0")) (str.to_re "2/29")) (re.++ (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8"))) (re.union (str.to_re "19") (re.++ (str.to_re "2") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\u{2e}rtf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.rtf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; NavExcel\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "NavExcel") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}")))))
; ^\d{3}-\d{7}[0-6]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "6")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

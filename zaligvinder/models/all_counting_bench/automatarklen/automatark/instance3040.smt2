(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; TM_SEARCH3Host\u{3a}User-Agent\x3Amedia\x2Edxcdirect\x2Ecom
(assert (not (str.in_re X (str.to_re "TM_SEARCH3Host:User-Agent:media.dxcdirect.com\u{0a}"))))
; ^((4(\d{12}|\d{15}))|(5\d{15})|(6011\d{12})|(3(4|7)\d{13}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "4") (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 15 15) (re.range "0" "9")))) (re.++ (str.to_re "5") ((_ re.loop 15 15) (re.range "0" "9"))) (re.++ (str.to_re "6011") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "4") (str.to_re "7")) ((_ re.loop 13 13) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

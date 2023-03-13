(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (NL-?)?[0-9]{9}B[0-9]{2}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "NL") (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "B") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; now\d+\x2Fbar_pl\x2Fshdoclc\.fcgiareHost\x3Ae2give\.com
(assert (not (str.in_re X (re.++ (str.to_re "now") (re.+ (re.range "0" "9")) (str.to_re "/bar_pl/shdoclc.fcgiareHost:e2give.com\u{0a}")))))
(check-sat)

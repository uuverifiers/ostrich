(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ('{2})*([^'\r\n]*)('{2})*([^'\r\n]*)('{2})*
(assert (str.in_re X (re.++ (re.* ((_ re.loop 2 2) (str.to_re "'"))) (re.* (re.union (str.to_re "'") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* ((_ re.loop 2 2) (str.to_re "'"))) (re.* (re.union (str.to_re "'") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* ((_ re.loop 2 2) (str.to_re "'"))) (str.to_re "\u{0a}"))))
; now\d+\x2Fbar_pl\x2Fshdoclc\.fcgiareHost\x3Ae2give\.com
(assert (str.in_re X (re.++ (str.to_re "now") (re.+ (re.range "0" "9")) (str.to_re "/bar_pl/shdoclc.fcgiareHost:e2give.com\u{0a}"))))
; ^\d+(\,\d{1,2})?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)

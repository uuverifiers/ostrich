(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([$])?((([0-9]{1,3},)+[0-9]{3})|[0-9]+)(\.[0-9]{2})?)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "$")) (re.union (re.++ (re.+ (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))))
; rprpgbnrppb\u{2f}ci\d\x2ElStopperHost\x3AHost\u{3a}clvompycem\u{2f}cen\.vcn
(assert (not (str.in_re X (re.++ (str.to_re "rprpgbnrppb/ci") (re.range "0" "9") (str.to_re ".lStopperHost:Host:clvompycem/cen.vcn\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

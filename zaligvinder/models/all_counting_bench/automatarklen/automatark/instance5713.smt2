(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{4}[1-8](\d){2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (re.range "1" "8") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; rprpgbnrppb\u{2f}ci\d\x2ElStopperHost\x3AHost\u{3a}clvompycem\u{2f}cen\.vcn
(assert (str.in_re X (re.++ (str.to_re "rprpgbnrppb/ci") (re.range "0" "9") (str.to_re ".lStopperHost:Host:clvompycem/cen.vcn\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eonlinecasinoextra\x2Ecomsqlads\.grokads\.com
(assert (str.in_re X (str.to_re "www.onlinecasinoextra.comsqlads.grokads.com\u{0a}")))
; \A([0-9a-zA-Z_]{1,15})|(@([0-9a-zA-Z_]{1,15}))\Z
(assert (str.in_re X (re.union ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.++ (str.to_re "\u{0a}@") ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_")))))))
; rprpgbnrppb\u{2f}ci\d\x2ElStopperHost\x3AHost\u{3a}clvompycem\u{2f}cen\.vcn
(assert (str.in_re X (re.++ (str.to_re "rprpgbnrppb/ci") (re.range "0" "9") (str.to_re ".lStopperHost:Host:clvompycem/cen.vcn\u{0a}"))))
(check-sat)

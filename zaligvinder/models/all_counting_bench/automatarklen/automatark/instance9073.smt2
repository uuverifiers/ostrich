(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProAgentHost\x3ALOGSeconds\-
(assert (str.in_re X (str.to_re "ProAgentHost:LOGSeconds-\u{0a}")))
; ^\d{5}$|^\d{5}-\d{4}$
(assert (str.in_re X (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (not (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

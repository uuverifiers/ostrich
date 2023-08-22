(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x3Cchat\x3EHost\x3Atid\x3D\x7B
(assert (str.in_re X (str.to_re "<chat>\u{1b}Host:tid={\u{0a}")))
; ^[0-9]{5}(-[0-9]{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; \x7D\x7BTrojan\x3A\w+Host\x3Arprpgbnrppb\u{2f}ci
(assert (str.in_re X (re.++ (str.to_re "}{Trojan:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:rprpgbnrppb/ci\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

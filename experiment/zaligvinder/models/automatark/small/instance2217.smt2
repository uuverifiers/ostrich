(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; activityHWAEHost\u{3a}MyWayServidor\x2EHANDYEmail
(assert (str.in_re X (str.to_re "activityHWAEHost:MyWayServidor.\u{13}HANDYEmail\u{0a}")))
; ^[a-zA-Z]\w{3,14}$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 3 14) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
(check-sat)

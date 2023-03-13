(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\{[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}\}$
(assert (not (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "}\u{0a}")))))
; /g\/\d{9}\/[0-9a-f]{32}\/[0-9]$/U
(assert (str.in_re X (re.++ (str.to_re "/g/") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/") (re.range "0" "9") (str.to_re "/U\u{0a}"))))
; ([0-9a-z_-]+[\.][0-9a-z_-]{1,3})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))))))
; activityHWAEHost\u{3a}MyWayServidor\x2EHANDYEmail
(assert (not (str.in_re X (str.to_re "activityHWAEHost:MyWayServidor.\u{13}HANDYEmail\u{0a}"))))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}")))
(check-sat)

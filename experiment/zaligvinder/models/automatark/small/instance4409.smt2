(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((079)|(078)|(077)){1}[0-9]{7}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "079") (str.to_re "078") (str.to_re "077"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; fsbuffshprrprt-cs-Host\x3A
(assert (str.in_re X (str.to_re "fsbuffshprrprt-cs-\u{13}Host:\u{0a}")))
; ^[a-zA-Z][a-zA-Z0-9_\.\-]+@([a-zA-Z0-9-]{2,}\.)+([a-zA-Z]{2,4}|[a-zA-Z]{2}\.[a-zA-Z]{2})$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (str.to_re "@") (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) (re.union ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}")))))
(check-sat)

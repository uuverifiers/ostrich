(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\{(.+)|^\\(.+)|(\}*)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "{") (re.+ re.allchar)) (re.++ (str.to_re "\u{5c}") (re.+ re.allchar)) (re.++ (re.* (str.to_re "}")) (str.to_re "\u{0a}"))))))
; ^((0|[1-9]+[0-9]*)-(0|[1-9]+[0-9]*);|(0|[1-9]+[0-9]*);)*?((0|[1-9]+[0-9]*)-(0|[1-9]+[0-9]*)|(0|[1-9]+[0-9]*)){1}$
(assert (str.in_re X (re.++ (re.* (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "-") (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re ";")) (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re ";")))) ((_ re.loop 1 1) (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "-") (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))) (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; Log[^\n\r]*Host\x3A\dHOST\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Log") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.range "0" "9") (str.to_re "HOST:User-Agent:\u{0a}")))))
; ^.*(yourdomain.com).*$
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.* re.allchar) (str.to_re "\u{0a}yourdomain") re.allchar (str.to_re "com")))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \.([A-Za-z0-9]{2,5}($|\b\?))
(assert (not (str.in_re X (re.++ (str.to_re ".\u{0a}") ((_ re.loop 2 5) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "?")))))
; ^((0?[1-9])|((1)[0-1]))?((\.[0-9]{0,2})?|0(\.[0-9]{0,2}))$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "1")))) (re.union (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re "0.") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3A.*User-Agent\u{3a}\sRequest
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Request\u{0a}")))))
; /^\/uploading\/id=\d+\&u=.*==$/U
(assert (str.in_re X (re.++ (str.to_re "//uploading/id=") (re.+ (re.range "0" "9")) (str.to_re "&u=") (re.* re.allchar) (str.to_re "==/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

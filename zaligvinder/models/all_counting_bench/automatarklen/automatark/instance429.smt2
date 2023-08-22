(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A.*User-Agent\u{3a}\sRequest
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Request\u{0a}")))))
; ^\d+(\.\d{2})?$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(01)[0-9]{8}
(assert (not (str.in_re X (re.++ (str.to_re "01") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(\(?[0-9]{3}[\)-\.]?\ ?)?[0-9]{3}[-\.]?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.range ")" ".")) (re.opt (str.to_re " ")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

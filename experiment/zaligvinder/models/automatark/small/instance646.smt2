(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Emaxifiles\x2Ecom.*Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.maxifiles.com") (re.* re.allchar) (str.to_re "Host:\u{0a}")))))
; /^simple\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/simple|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; /^(1)?(-|.)?(\()?([0-9]{3})(\))?(-|.)?([0-9]{3})(-|.)?([0-9]{4})/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") re.allchar)) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
(check-sat)

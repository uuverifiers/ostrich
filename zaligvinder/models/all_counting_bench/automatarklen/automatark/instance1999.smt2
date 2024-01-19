(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Logger.*Host\x3A.*\x2Fcommunicatortb\u{7c}roogoo\u{7c}
(assert (str.in_re X (re.++ (str.to_re "Logger") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "/communicatortb|roogoo|\u{0a}"))))
; ^0[1-9]\d{7,8}$
(assert (not (str.in_re X (re.++ (str.to_re "0") (re.range "1" "9") ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}ru\/\w+\?\d$/miU
(assert (not (str.in_re X (re.++ (str.to_re "/.ru/") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "?") (re.range "0" "9") (str.to_re "/miU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

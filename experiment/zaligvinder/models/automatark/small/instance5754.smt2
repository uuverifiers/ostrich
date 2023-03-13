(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0?[1-9]|1[012])/([012][0-9]|[1-9]|3[01])/([12][0-9]{3})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.range "1" "9") (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "/\u{0a}") (re.union (str.to_re "1") (str.to_re "2")) ((_ re.loop 3 3) (re.range "0" "9"))))))
; Toolbar\d+Host\x3AWelcome\x2FcommunicatortbGateCrasher
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "Host:Welcome/communicatortbGateCrasher\u{0a}"))))
; /\u{2e}pfm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.pfm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /\u{2e}xfdl([\?\u{5c}\u{2f}]|$)/miU
(assert (not (str.in_re X (re.++ (str.to_re "/.xfdl") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/miU\u{0a}")))))
(check-sat)

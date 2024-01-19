(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(\u{75}|\u{2d}|\u{2f}|\u{73}|\u{a2}|\u{2e}|\u{24}|\u{74})/sR
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "u") (str.to_re "-") (str.to_re "/") (str.to_re "s") (str.to_re "\u{a2}") (str.to_re ".") (str.to_re "$") (str.to_re "t")) (str.to_re "/sR\u{0a}")))))
; /filename=[^\n]*\u{2e}pfa/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfa/i\u{0a}"))))
; ^(0?\d|1[012])\/([012]?\d|3[01])\/(\d{2}|\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2"))) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "/") (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; adfsgecoiwnf\d+Host\u{3a}TCP\x2FAD\x2FULOGNetBus
(assert (not (str.in_re X (re.++ (str.to_re "adfsgecoiwnf\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "Host:TCP/AD/ULOGNetBus\u{0a}")))))
; /\u{2e}jnlp([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jnlp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

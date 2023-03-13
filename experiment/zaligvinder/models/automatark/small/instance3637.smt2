(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-z0-9]+\/access\.log$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/access.log/Ui\u{0a}"))))
; /\u{2e}js\u{3f}[a-zA-Z0-9]{9,20}=Mozilla\u{2f}/UGi
(assert (not (str.in_re X (re.++ (str.to_re "/.js?") ((_ re.loop 9 20) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "=Mozilla//UGi\u{0a}")))))
; Subject\x3AHost\u{3a}Host\x3A000Filelogin_ok\x5EMiniCommand
(assert (str.in_re X (str.to_re "Subject:Host:Host:000Filelogin_ok^MiniCommand\u{0a}")))
; /filename=[^\n]*\u{2e}xul/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xul/i\u{0a}")))))
(check-sat)

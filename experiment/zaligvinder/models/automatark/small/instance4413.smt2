(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}pls/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pls/i\u{0a}"))))
; MyverToolbarTrojanControlHost\x3A
(assert (str.in_re X (str.to_re "MyverToolbarTrojanControlHost:\u{0a}")))
; ^\d{1,5}(\.\d{1,2})?$
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\/[a-zA-Z0-9]{32}\.jar/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}")))))
(check-sat)

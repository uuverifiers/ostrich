(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\(?[0-9]{3}[\)-\.]?\ ?)?[0-9]{3}[-\.]?[0-9]{4}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.range ")" ".")) (re.opt (str.to_re " ")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2f}x\u{2f}[0-9a-z]{8,10}\u{2f}[0-9a-f]{32}\u{2f}AA\u{2f}0$/U
(assert (not (str.in_re X (re.++ (str.to_re "//x/") ((_ re.loop 8 10) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/AA/0/U\u{0a}")))))
; /filename=[^\n]*\u{2e}gz/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".gz/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

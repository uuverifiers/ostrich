(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mka/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mka/i\u{0a}"))))
; /^\/\?[a-z0-9]{2}\=[a-z1-9]{100}/siU
(assert (not (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 100 100) (re.union (re.range "a" "z") (re.range "1" "9"))) (str.to_re "/siU\u{0a}")))))
(check-sat)

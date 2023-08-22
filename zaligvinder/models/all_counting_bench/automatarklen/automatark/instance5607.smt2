(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /g\/\d{9}\/[0-9a-f]{32}\/[0-9]$/U
(assert (not (str.in_re X (re.++ (str.to_re "/g/") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/") (re.range "0" "9") (str.to_re "/U\u{0a}")))))
; /filename=[^\n]*\u{2e}wma/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wma/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

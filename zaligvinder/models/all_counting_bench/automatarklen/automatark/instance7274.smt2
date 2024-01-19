(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \A([0-9a-zA-Z_]{1,15})|(@([0-9a-zA-Z_]{1,15}))\Z
(assert (not (str.in_re X (re.union ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.++ (str.to_re "\u{0a}@") ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))))))))
; /filename=[^\n]*\u{2e}fon/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fon/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

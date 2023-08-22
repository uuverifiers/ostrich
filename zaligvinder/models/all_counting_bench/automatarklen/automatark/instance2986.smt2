(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-f0-9]{32}\.eot$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".eot/U\u{0a}")))))
; /filename=[^\n]*\u{2e}xul/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xul/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

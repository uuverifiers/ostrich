(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^.+@[^\.].*\.[a-z]{2,}$
(assert (str.in_re X (re.++ (re.+ re.allchar) (str.to_re "@") (re.comp (str.to_re ".")) (re.* re.allchar) (str.to_re ".\u{0a}") ((_ re.loop 2 2) (re.range "a" "z")) (re.* (re.range "a" "z")))))
; /filename=[^\n]*\u{2e}m4r/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4r/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

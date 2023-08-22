(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}m4v/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4v/i\u{0a}")))))
; (^\d{5}\x2D\d{3}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)

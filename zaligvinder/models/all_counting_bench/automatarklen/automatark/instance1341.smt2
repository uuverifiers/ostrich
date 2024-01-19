(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}SpywareSpyBuddy
(assert (str.in_re X (str.to_re "Subject:SpywareSpyBuddy\u{0a}")))
; /filename=[^\n]*\u{2e}smil/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".smil/i\u{0a}")))))
; \b[1-9]{1}[0-9]{1,5}-\d{2}-\d\b
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}rat/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rat/i\u{0a}")))))
; ^\d{1,3}\.\d{1,4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \x2Fxml\x2Ftoolbar\x2FExploiter
(assert (not (str.in_re X (str.to_re "/xml/toolbar/Exploiter\u{0a}"))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}met([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.met") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /filename=[^\n]*\u{2e}pui/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pui/i\u{0a}"))))
; /^\/[a-f0-9]{32}\/[0-9]$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") (re.range "0" "9") (str.to_re "/Ui\u{0a}")))))
; (?i:[aeiou]+)\B
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "a") (str.to_re "e") (str.to_re "i") (str.to_re "o") (str.to_re "u"))) (str.to_re "\u{0a}")))))
; Validation of Mexican RFC for tax payers (individuals)
(assert (not (str.in_re X (str.to_re "Validation of Mexican RFC for tax payers individuals\u{0a}"))))
(check-sat)

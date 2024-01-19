(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}pfb/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfb/i\u{0a}")))))
; (^(30)[0-5]\d{11}$)|(^(36)\d{12}$)|(^(38[0-8])\d{11}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "30") (re.range "0" "5") ((_ re.loop 11 11) (re.range "0" "9"))) (re.++ (str.to_re "36") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "38") (re.range "0" "8")))))
; /filename=[^\n]*\u{2e}wax/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wax/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

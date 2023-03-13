(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1}(\.\d{3})-\d{3}(\.\d{1})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}.") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}cov/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cov/i\u{0a}")))))
(check-sat)

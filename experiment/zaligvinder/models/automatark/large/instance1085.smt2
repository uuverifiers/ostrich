(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{5,12}|\d{1,10}\.\d{1,10}\.\d{1,10}|\d{1,10}\.\d{1,10}
(assert (str.in_re X (re.union ((_ re.loop 5 12) (re.range "0" "9")) (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9"))) (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}dcr/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dcr/i\u{0a}"))))
(check-sat)

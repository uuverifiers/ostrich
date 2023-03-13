(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CUSTOM\swww\x2Elocators\x2Ecomas\x2Estarware\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "CUSTOM") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.locators.comas.starware.com\u{0a}")))))
; ^\d{1,2}\/\d{1,2}\/\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)

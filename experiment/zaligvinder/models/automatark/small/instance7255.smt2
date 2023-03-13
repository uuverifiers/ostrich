(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Searchdata2\.activshopper\.comdll\x3FproductsCUSTOMSAccwww\x2Elocators\x2Ecom
(assert (str.in_re X (str.to_re "Searchdata2.activshopper.comdll?productsCUSTOMSAccwww.locators.com\u{0a}")))
; /\u{2e}wpd([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.wpd") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(\d{3}|\d{4})[-](\d{5})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)

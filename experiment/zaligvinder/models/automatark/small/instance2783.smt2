(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d{3}\-\d{2}\-\d{4})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))))
; User-Agent\x3A[^\n\r]*aadserver\dYOUR\x2Fxml\x2Ftoolbar\x2F
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "aadserver") (re.range "0" "9") (str.to_re "YOUR/xml/toolbar/\u{0a}")))))
(check-sat)

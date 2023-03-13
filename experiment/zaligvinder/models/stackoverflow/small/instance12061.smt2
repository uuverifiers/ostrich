;test regex 612[1-5]00(?:[0-5][0-9]|6[0-4])0000(?:0[0-9]|[1-5][0-9]|6[0-4])00[0-9]{4}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "612") (re.++ (re.range "1" "5") (re.++ (str.to_re "00") (re.++ (re.union (re.++ (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "6") (re.range "0" "4"))) (re.++ (str.to_re "0000") (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (re.range "1" "5") (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4"))) (re.++ (str.to_re "00") ((_ re.loop 4 4) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
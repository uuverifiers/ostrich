;test regex "^\\d{4}-[0-1][0-3]-[0-3]\\d{1}T[0-2]\\d{1}:[0-5]\\d{1}:[0-5]\\d{1}Z$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (re.++ (str.to_re "-") (re.++ (re.range "0" "1") (re.++ (re.range "0" "3") (re.++ (str.to_re "-") (re.++ (re.range "0" "3") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 1) (str.to_re "d")) (re.++ (str.to_re "T") (re.++ (re.range "0" "2") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 1) (str.to_re "d")) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 1) (str.to_re "d")) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "Z")))))))))))))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
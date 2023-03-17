;test regex "\\d{4}-[01]\\d-[0-3]\\d\\s[0-2](\\d:[0-5]\\d:([0-5]\\d)?)?"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (re.++ (str.to_re "-") (re.++ (str.to_re "01") (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re "-") (re.++ (re.range "0" "3") (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (re.range "0" "2") (re.++ (re.opt (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re ":") (re.opt (re.++ (re.range "0" "5") (re.++ (str.to_re "\\") (str.to_re "d")))))))))))) (str.to_re "\u{22}"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
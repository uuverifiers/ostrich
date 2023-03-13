;test regex ^\$(?:1,?\d{3}(?:\.\d\d?)?|2000(?:\.00?)?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "$") (re.union (re.++ (str.to_re "1") (re.++ (re.opt (str.to_re ",")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.++ (re.range "0" "9") (re.opt (re.range "0" "9")))))))) (re.++ (str.to_re "2000") (re.opt (re.++ (str.to_re ".") (re.opt (str.to_re "00")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
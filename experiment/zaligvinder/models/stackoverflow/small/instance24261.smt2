;test regex (\d{1,2})(st|nd|rd|th)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (re.union (re.union (re.++ (str.to_re "s") (str.to_re "t")) (re.++ (str.to_re "n") (str.to_re "d"))) (re.++ (str.to_re "r") (str.to_re "d"))) (re.++ (str.to_re "t") (str.to_re "h"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
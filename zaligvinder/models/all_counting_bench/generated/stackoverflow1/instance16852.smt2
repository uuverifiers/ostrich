;test regex (?:(Sheet\d+\.)??([A-Z]{1,2}?)([1-9]+))*
(declare-const X String)
(assert (str.in_re X (re.* (re.++ (re.opt (re.++ (str.to_re "S") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (re.+ (re.range "0" "9")) (str.to_re ".")))))))) (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.+ (re.range "1" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
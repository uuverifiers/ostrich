;test regex \$(I|II|III|IV|V|VI)(\.[0-9]{1,2})+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "$") (re.++ (re.union (re.union (re.union (re.union (re.union (str.to_re "I") (re.++ (str.to_re "I") (str.to_re "I"))) (re.++ (str.to_re "I") (re.++ (str.to_re "I") (str.to_re "I")))) (re.++ (str.to_re "I") (str.to_re "V"))) (str.to_re "V")) (re.++ (str.to_re "V") (str.to_re "I"))) (re.+ (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
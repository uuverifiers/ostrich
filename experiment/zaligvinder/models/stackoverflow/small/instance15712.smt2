;test regex (DE)([0-9]{1,12})((?:[ABCUT][0-9]?)?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "D") (str.to_re "E")) (re.++ ((_ re.loop 1 12) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "U") (str.to_re "T"))))) (re.opt (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
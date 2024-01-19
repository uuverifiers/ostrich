;test regex ~(A{1}B?C?(D*|E*|F*|G*)+){1}~
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "~") (re.++ ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (str.to_re "A")) (re.++ (re.opt (str.to_re "B")) (re.++ (re.opt (str.to_re "C")) (re.+ (re.union (re.union (re.union (re.* (str.to_re "D")) (re.* (str.to_re "E"))) (re.* (str.to_re "F"))) (re.* (str.to_re "G")))))))) (str.to_re "~")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
;test regex ^(?:(.+)?\d+(.+)?){8}|null$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") ((_ re.loop 8 8) (re.++ (re.opt (re.+ (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.+ (re.range "0" "9")) (re.opt (re.+ (re.diff re.allchar (str.to_re "\n")))))))) (re.++ (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (str.to_re "l")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
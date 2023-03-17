;test regex ([\\pL]{2}=[\\pL|\\pN|\\pP]+ )+
(declare-const X String)
(assert (str.in_re X (re.+ (re.++ ((_ re.loop 2 2) (re.union (str.to_re "\\") (re.union (str.to_re "p") (str.to_re "L")))) (re.++ (str.to_re "=") (re.++ (re.+ (re.union (str.to_re "\\") (re.union (str.to_re "p") (re.union (str.to_re "L") (re.union (str.to_re "|") (re.union (str.to_re "\\") (re.union (str.to_re "p") (re.union (str.to_re "N") (re.union (str.to_re "|") (re.union (str.to_re "\\") (re.union (str.to_re "p") (str.to_re "P")))))))))))) (str.to_re " ")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
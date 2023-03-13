;test regex (([gG]{3,}[aAtTgGcC]{1,7}){3,}[gG]{3,})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.++ (re.++ (re.* (re.union (str.to_re "g") (str.to_re "G"))) ((_ re.loop 3 3) (re.union (str.to_re "g") (str.to_re "G")))) ((_ re.loop 1 7) (re.union (str.to_re "a") (re.union (str.to_re "A") (re.union (str.to_re "t") (re.union (str.to_re "T") (re.union (str.to_re "g") (re.union (str.to_re "G") (re.union (str.to_re "c") (str.to_re "C"))))))))))) ((_ re.loop 3 3) (re.++ (re.++ (re.* (re.union (str.to_re "g") (str.to_re "G"))) ((_ re.loop 3 3) (re.union (str.to_re "g") (str.to_re "G")))) ((_ re.loop 1 7) (re.union (str.to_re "a") (re.union (str.to_re "A") (re.union (str.to_re "t") (re.union (str.to_re "T") (re.union (str.to_re "g") (re.union (str.to_re "G") (re.union (str.to_re "c") (str.to_re "C")))))))))))) (re.++ (re.* (re.union (str.to_re "g") (str.to_re "G"))) ((_ re.loop 3 3) (re.union (str.to_re "g") (str.to_re "G")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
;test regex (([?!G]{3,}[ATGC]{1,7}){3,}[G]{3,})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.++ (re.++ (re.* (re.union (str.to_re "?") (re.union (str.to_re "!") (str.to_re "G")))) ((_ re.loop 3 3) (re.union (str.to_re "?") (re.union (str.to_re "!") (str.to_re "G"))))) ((_ re.loop 1 7) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "G") (str.to_re "C"))))))) ((_ re.loop 3 3) (re.++ (re.++ (re.* (re.union (str.to_re "?") (re.union (str.to_re "!") (str.to_re "G")))) ((_ re.loop 3 3) (re.union (str.to_re "?") (re.union (str.to_re "!") (str.to_re "G"))))) ((_ re.loop 1 7) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "G") (str.to_re "C")))))))) (re.++ (re.* (str.to_re "G")) ((_ re.loop 3 3) (str.to_re "G"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
;test regex ^M{0,1}T{0,1}W{0,1}(TH){0,1}F{0,1}S{0,1}(SU){0,1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 1) (str.to_re "M")) (re.++ ((_ re.loop 0 1) (str.to_re "T")) (re.++ ((_ re.loop 0 1) (str.to_re "W")) (re.++ ((_ re.loop 0 1) (re.++ (str.to_re "T") (str.to_re "H"))) (re.++ ((_ re.loop 0 1) (str.to_re "F")) (re.++ ((_ re.loop 0 1) (str.to_re "S")) ((_ re.loop 0 1) (re.++ (str.to_re "S") (str.to_re "U")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
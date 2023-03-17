;test regex ^(?:M{1,3})?(?:CM|C?D|D?C{1,3})?(?:X?L|XC|L?X{1,3})?(?:I?V|IX|V?I{1,3})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt ((_ re.loop 1 3) (str.to_re "M"))) (re.++ (re.opt (re.union (re.union (re.++ (str.to_re "C") (str.to_re "M")) (re.++ (re.opt (str.to_re "C")) (str.to_re "D"))) (re.++ (re.opt (str.to_re "D")) ((_ re.loop 1 3) (str.to_re "C"))))) (re.++ (re.opt (re.union (re.union (re.++ (re.opt (str.to_re "X")) (str.to_re "L")) (re.++ (str.to_re "X") (str.to_re "C"))) (re.++ (re.opt (str.to_re "L")) ((_ re.loop 1 3) (str.to_re "X"))))) (re.opt (re.union (re.union (re.++ (re.opt (str.to_re "I")) (str.to_re "V")) (re.++ (str.to_re "I") (str.to_re "X"))) (re.++ (re.opt (str.to_re "V")) ((_ re.loop 1 3) (str.to_re "I"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
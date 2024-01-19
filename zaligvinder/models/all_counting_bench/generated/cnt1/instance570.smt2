;test regex ^12[0-9]{9}|13[0-9]{9}|14[579]{1}[0-9]{8}|15[012356789]{1}[0-9]{8}|17[0135678]{1}[0-9]{8}|18[0-9]{9}$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (str.to_re "12") ((_ re.loop 9 9) (re.range "0" "9")))) (re.++ (str.to_re "13") ((_ re.loop 9 9) (re.range "0" "9")))) (re.++ (str.to_re "14") (re.++ ((_ re.loop 1 1) (str.to_re "579")) ((_ re.loop 8 8) (re.range "0" "9"))))) (re.++ (str.to_re "15") (re.++ ((_ re.loop 1 1) (str.to_re "012356789")) ((_ re.loop 8 8) (re.range "0" "9"))))) (re.++ (str.to_re "17") (re.++ ((_ re.loop 1 1) (str.to_re "0135678")) ((_ re.loop 8 8) (re.range "0" "9"))))) (re.++ (re.++ (str.to_re "18") ((_ re.loop 9 9) (re.range "0" "9"))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
;test regex (^0{3}[^\ddrv])?(^0{4}_)?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (str.to_re "0")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.inter (re.diff re.allchar (str.to_re "d")) (re.inter (re.diff re.allchar (str.to_re "r")) (re.diff re.allchar (str.to_re "v")))))))) (re.opt (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (str.to_re "0")) (str.to_re "_")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
;test regex ^.{4}[2-7]{3}(_[0-9]{3}){2}(\[.+?\])?(_[1-9][0-9]{0,2})?(#[1-9][0-9]{0,2})?\.png$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 3 3) (re.range "2" "7")) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "_") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.opt (re.++ (str.to_re "[") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "]")))) (re.++ (re.opt (re.++ (str.to_re "_") (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (re.opt (re.++ (str.to_re "#") (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
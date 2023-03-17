;test regex @"^.{4}[2-7](_\d{3}){2}(\[.+\])?(_\d{1,3})?(\#\d{1,3})?\.png$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.range "2" "7") (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "_") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.opt (re.++ (str.to_re "[") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "]")))) (re.++ (re.opt (re.++ (str.to_re "_") ((_ re.loop 1 3) (re.range "0" "9")))) (re.++ (re.opt (re.++ (str.to_re "#") ((_ re.loop 1 3) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
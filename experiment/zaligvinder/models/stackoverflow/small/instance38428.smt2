;test regex (abc|def)(([0-9])|([0-9][0-9]{0,1})|([0-8][0-9]{0,2})|(900))($|[^0-9][^(abc|def)]*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c"))) (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "f")))) (re.++ (re.union (re.union (re.union (re.range "0" "9") (re.++ (re.range "0" "9") ((_ re.loop 0 1) (re.range "0" "9")))) (re.++ (re.range "0" "8") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "900")) (re.union (str.to_re "") (re.++ (re.diff re.allchar (re.range "0" "9")) (re.* (re.inter (re.diff re.allchar (str.to_re "(")) (re.inter (re.diff re.allchar (str.to_re "a")) (re.inter (re.diff re.allchar (str.to_re "b")) (re.inter (re.diff re.allchar (str.to_re "c")) (re.inter (re.diff re.allchar (str.to_re "|")) (re.inter (re.diff re.allchar (str.to_re "d")) (re.inter (re.diff re.allchar (str.to_re "e")) (re.inter (re.diff re.allchar (str.to_re "f")) (re.diff re.allchar (str.to_re ")")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
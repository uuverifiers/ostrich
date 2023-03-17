;test regex "([1-9][0-9]*[\\.|,][0-9]{2})[^\\.\\d](.*)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.range "1" "9") (re.++ (re.* (re.range "0" "9")) (re.++ (re.union (str.to_re "\\") (re.union (str.to_re ".") (re.union (str.to_re "|") (str.to_re ",")))) ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (re.inter (re.diff re.allchar (str.to_re "\\")) (re.inter (re.diff re.allchar (str.to_re ".")) (re.inter (re.diff re.allchar (str.to_re "\\")) (re.diff re.allchar (str.to_re "d"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
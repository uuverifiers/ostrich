;test regex (?:\n|\t|\r|.){1,3}.*\@sc.*'
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.union (re.union (re.union (str.to_re "\u{0a}") (str.to_re "\u{09}")) (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "@") (re.++ (str.to_re "s") (re.++ (str.to_re "c") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{27}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
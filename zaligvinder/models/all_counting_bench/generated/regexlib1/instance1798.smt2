;test regex ^((http|https|ftp|ftps)+(:\/\/))?(www\.)?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.+ (re.union (re.union (re.union (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (str.to_re "p")))) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (str.to_re "s")))))) (re.++ (str.to_re "f") (re.++ (str.to_re "t") (str.to_re "p")))) (re.++ (str.to_re "f") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (str.to_re "s")))))) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (str.to_re "/"))))) (re.opt (re.++ (str.to_re "w") (re.++ (str.to_re "w") (re.++ (str.to_re "w") (str.to_re ".")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
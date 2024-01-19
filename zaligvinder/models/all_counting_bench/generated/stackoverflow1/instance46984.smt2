;test regex (\d{4}[-.()\/* ]*(?:(?:x|ext)[:]?[ ]*\d+)?)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.* (re.union (str.to_re "-") (re.union (str.to_re ".") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "/") (re.union (str.to_re "*") (str.to_re " ")))))))) (re.opt (re.++ (re.union (str.to_re "x") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re "t")))) (re.++ (re.opt (str.to_re ":")) (re.++ (re.* (str.to_re " ")) (re.+ (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
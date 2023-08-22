;test regex ^[4903|4911|4936|5641|6333|6759|6334|6767]\d{12}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "4903") (re.union (str.to_re "|") (re.union (str.to_re "4911") (re.union (str.to_re "|") (re.union (str.to_re "4936") (re.union (str.to_re "|") (re.union (str.to_re "5641") (re.union (str.to_re "|") (re.union (str.to_re "6333") (re.union (str.to_re "|") (re.union (str.to_re "6759") (re.union (str.to_re "|") (re.union (str.to_re "6334") (re.union (str.to_re "|") (str.to_re "6767"))))))))))))))) ((_ re.loop 12 12) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
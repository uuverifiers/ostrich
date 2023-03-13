;test regex (^2\d{0,8}$)|(^(31|32|35|37|38|39|41|46|47|48|49|50|51|52|53|54|55|56|57|58|59|60)\d{0,7}$)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "2") ((_ re.loop 0 8) (re.range "0" "9")))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "31") (str.to_re "32")) (str.to_re "35")) (str.to_re "37")) (str.to_re "38")) (str.to_re "39")) (str.to_re "41")) (str.to_re "46")) (str.to_re "47")) (str.to_re "48")) (str.to_re "49")) (str.to_re "50")) (str.to_re "51")) (str.to_re "52")) (str.to_re "53")) (str.to_re "54")) (str.to_re "55")) (str.to_re "56")) (str.to_re "57")) (str.to_re "58")) (str.to_re "59")) (str.to_re "60")) ((_ re.loop 0 7) (re.range "0" "9")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
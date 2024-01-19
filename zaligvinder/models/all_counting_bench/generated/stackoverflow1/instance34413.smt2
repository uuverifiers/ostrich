;test regex ^[\d]{1,2}[.|:]?[\d]{0,2}[\s]?[am|pm|AM|PM]{0,2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re ".") (re.union (str.to_re "|") (str.to_re ":")))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) ((_ re.loop 0 2) (re.union (str.to_re "a") (re.union (str.to_re "m") (re.union (str.to_re "|") (re.union (str.to_re "p") (re.union (str.to_re "m") (re.union (str.to_re "|") (re.union (str.to_re "A") (re.union (str.to_re "M") (re.union (str.to_re "|") (re.union (str.to_re "P") (str.to_re "M")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
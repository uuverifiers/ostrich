;test regex (?:(?:|(\\|))f-150|keep|those):|(?:^|\\|)\\w-\\d{3}:\\w{2}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.union (re.union (re.++ (re.union (re.++ (str.to_re "") (re.union (re.++ (str.to_re "") (str.to_re "\\")) (str.to_re ""))) (str.to_re "")) (re.++ (str.to_re "f") (re.++ (str.to_re "-") (str.to_re "150")))) (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (str.to_re "p"))))) (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "s") (str.to_re "e")))))) (str.to_re ":")) (re.++ (re.union (re.++ (str.to_re "") (re.union (str.to_re "") (str.to_re "\\"))) (str.to_re "")) (re.++ (str.to_re "\\") (re.++ (str.to_re "w") (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.++ (str.to_re ":") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "w")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
;test regex ^(Mon|Tues|Wed|Thurs|Fri|Sat|Sun)(,(Mon|Tues|Wed|Thurs|Fri|Sat|Sun)){0,6}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "o") (str.to_re "n"))) (re.++ (str.to_re "T") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (str.to_re "s"))))) (re.++ (str.to_re "W") (re.++ (str.to_re "e") (str.to_re "d")))) (re.++ (str.to_re "T") (re.++ (str.to_re "h") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (str.to_re "s")))))) (re.++ (str.to_re "F") (re.++ (str.to_re "r") (str.to_re "i")))) (re.++ (str.to_re "S") (re.++ (str.to_re "a") (str.to_re "t")))) (re.++ (str.to_re "S") (re.++ (str.to_re "u") (str.to_re "n")))) ((_ re.loop 0 6) (re.++ (str.to_re ",") (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "o") (str.to_re "n"))) (re.++ (str.to_re "T") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (str.to_re "s"))))) (re.++ (str.to_re "W") (re.++ (str.to_re "e") (str.to_re "d")))) (re.++ (str.to_re "T") (re.++ (str.to_re "h") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (str.to_re "s")))))) (re.++ (str.to_re "F") (re.++ (str.to_re "r") (str.to_re "i")))) (re.++ (str.to_re "S") (re.++ (str.to_re "a") (str.to_re "t")))) (re.++ (str.to_re "S") (re.++ (str.to_re "u") (str.to_re "n")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
;test regex (^[a-fA-F\\d]{1,2})((\\s[a-fA-F\\d]{2})*)([a-fA-F\\d]{1,2}$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 1 2) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.union (str.to_re "\\") (str.to_re "d")))))) (re.++ (re.* (re.++ (str.to_re "\\") (re.++ (str.to_re "s") ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.union (str.to_re "\\") (str.to_re "d")))))))) (re.++ ((_ re.loop 1 2) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.union (str.to_re "\\") (str.to_re "d"))))) (str.to_re ""))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
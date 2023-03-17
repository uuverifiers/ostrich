;test regex ([a-zA-Z.\-_]+[=!<>]{0,2}([\"\']?[a-zA-Z\-!._ "\']*?[\"\']|[0-9]*))[ ]?(and|or|not)?[ ]?
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re ".") (re.union (str.to_re "-") (str.to_re "_")))))) (re.++ ((_ re.loop 0 2) (re.union (str.to_re "=") (re.union (str.to_re "!") (re.union (str.to_re "<") (str.to_re ">"))))) (re.union (re.++ (re.opt (re.union (str.to_re "\u{22}") (str.to_re "\u{27}"))) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "-") (re.union (str.to_re "!") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (str.to_re " ") (re.union (str.to_re "\u{22}") (str.to_re "\u{27}")))))))))) (re.union (str.to_re "\u{22}") (str.to_re "\u{27}")))) (re.* (re.range "0" "9"))))) (re.++ (re.opt (str.to_re " ")) (re.++ (re.opt (re.union (re.union (re.++ (str.to_re "a") (re.++ (str.to_re "n") (str.to_re "d"))) (re.++ (str.to_re "o") (str.to_re "r"))) (re.++ (str.to_re "n") (re.++ (str.to_re "o") (str.to_re "t"))))) (re.opt (str.to_re " ")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
;test regex ^(0|(([1-9]{1}|[1-9]{1}[0-9]{1}|[1-9]{1}[0-9]{2}){1}(\ [0-9]{3}){0,})),(([0-9]{2})|\-\-)([\ ]{1})(|EUR|EURO){1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.union (str.to_re "0") (re.++ ((_ re.loop 1 1) (re.union (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (re.* (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 0 0) (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")))))))) (re.++ (str.to_re ",") (re.++ (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (str.to_re "-"))) (re.++ ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 1 1) (re.union (str.to_re "") (re.++ (str.to_re "") (re.union (re.++ (str.to_re "E") (re.++ (str.to_re "U") (str.to_re "R"))) (re.++ (str.to_re "E") (re.++ (str.to_re "U") (re.++ (str.to_re "R") (str.to_re "O")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
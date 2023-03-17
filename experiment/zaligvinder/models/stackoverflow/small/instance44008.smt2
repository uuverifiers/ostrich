;test regex /^([+]39)?((3[\d]{2})([ ,\-,\/]){0,1}([\d, ]{6,9}))|(((0[\d]{1,4}))([ ,\-,\/]){0,1}([\d, ]{5,10}))$/
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.opt (re.++ (str.to_re "+") (str.to_re "39"))) (re.++ (re.++ (str.to_re "3") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (re.union (str.to_re ",") (re.union (str.to_re "-") (re.union (str.to_re ",") (str.to_re "/")))))) ((_ re.loop 6 9) (re.union (re.range "0" "9") (re.union (str.to_re ",") (str.to_re " "))))))))) (re.++ (re.++ (re.++ (str.to_re "0") ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (re.union (str.to_re ",") (re.union (str.to_re "-") (re.union (str.to_re ",") (str.to_re "/")))))) ((_ re.loop 5 10) (re.union (re.range "0" "9") (re.union (str.to_re ",") (str.to_re " ")))))) (re.++ (str.to_re "") (str.to_re "/"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
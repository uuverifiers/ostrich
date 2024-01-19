;test regex $var1=$var1 -replace('&#x[\dA-F]{2};|\s','_')
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "1") (str.to_re "=")))))) (re.++ (str.to_re "") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.union (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "x") (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re ";")))))) (re.++ (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (str.to_re "\u{27}")) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "_") (str.to_re "\u{27}")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
;test regex ([0-9A-Za-z\-_]{1,12}) \u0022b\u0022f #([0-9A-Za-z\-_\@]{8,10})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 12) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "-") (str.to_re "_")))))) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{0022b}") (re.++ (str.to_re "\u{0022f}") (re.++ (str.to_re " ") (re.++ (str.to_re "#") ((_ re.loop 8 10) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "-") (re.union (str.to_re "_") (str.to_re "@")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
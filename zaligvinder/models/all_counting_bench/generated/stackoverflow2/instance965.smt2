;test regex Track 1:  ^%B\d{0,19}\^[\w\s\/]{2,26}\^\d{7}\w*\?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "T") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re " ") (re.++ (str.to_re "1") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (str.to_re " ")))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "%") (re.++ (str.to_re "B") (re.++ ((_ re.loop 0 19) (re.range "0" "9")) (re.++ (str.to_re "^") (re.++ ((_ re.loop 2 26) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (str.to_re "/")))) (re.++ (str.to_re "^") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (str.to_re "?"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
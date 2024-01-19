;test regex ^[A-Za-z0_9_]{2}(.*?) +[A-Za-z0_9_]{4}|[A-Za-z0_9_]{3,}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "0") (re.union (str.to_re "_") (re.union (str.to_re "9") (str.to_re "_"))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.+ (str.to_re " ")) ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "0") (re.union (str.to_re "_") (re.union (str.to_re "9") (str.to_re "_"))))))))))) (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "0") (re.union (str.to_re "_") (re.union (str.to_re "9") (str.to_re "_"))))))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "0") (re.union (str.to_re "_") (re.union (str.to_re "9") (str.to_re "_")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
;test regex (\n{2,})([ \w,()%+\-:.]{2,75}[^.:])(\n{1,})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (str.to_re "\u{0a}")) ((_ re.loop 2 2) (str.to_re "\u{0a}"))) (re.++ (re.++ ((_ re.loop 2 75) (re.union (str.to_re " ") (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.union (str.to_re ",") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "%") (re.union (str.to_re "+") (re.union (str.to_re "-") (re.union (str.to_re ":") (str.to_re "."))))))))))) (re.inter (re.diff re.allchar (str.to_re ".")) (re.diff re.allchar (str.to_re ":")))) (re.++ (re.* (str.to_re "\u{0a}")) ((_ re.loop 1 1) (str.to_re "\u{0a}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)
;test regex ^(.+?) ((?:AA|BB|CC|DD|EE|[, ]+){0,6})(\d+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 0 6) (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "A")) (re.++ (str.to_re "B") (str.to_re "B"))) (re.++ (str.to_re "C") (str.to_re "C"))) (re.++ (str.to_re "D") (str.to_re "D"))) (re.++ (str.to_re "E") (str.to_re "E"))) (re.+ (re.union (str.to_re ",") (str.to_re " "))))) (re.+ (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
;test regex SELECT REGEXP_EXTRACT(str, r'^(.*)(?:\|[^|]+){7}$')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re "_") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "t") (str.to_re "r"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (str.to_re "\u{27}"))))) (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 7 7) (re.++ (str.to_re "|") (re.+ (re.diff re.allchar (str.to_re "|")))))))) (re.++ (str.to_re "") (str.to_re "\u{27}"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
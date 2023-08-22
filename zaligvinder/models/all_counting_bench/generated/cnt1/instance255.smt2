;test regex ^:61:(\d{6})(C|D)(\d+),(\d{0,2})\w{4}\w{1}(\d{9}|NONREF|EREF)(.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re ":") (re.++ (str.to_re "61") (re.++ (str.to_re ":") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.union (str.to_re "C") (str.to_re "D")) (re.+ (re.range "0" "9")))))))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.union (re.union ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (str.to_re "F"))))))) (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (str.to_re "F"))))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
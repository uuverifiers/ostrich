;test regex %?([0-9]{1})([0-9]{1})([A-Z0-9 ]{11})([A-Z0-9 ]{2})([A-Z0-9 ]{10})([A-Z0-9 ]{4})([1-2]{1})([0-9]{3})([0-9]{3})([A-Z ]{3})([A-Z ]{3})(.*)\?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "%")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 11 11) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re " ")))) (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re " ")))) (re.++ ((_ re.loop 10 10) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re " ")))) (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re " ")))) (re.++ ((_ re.loop 1 1) (re.range "1" "2")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (str.to_re " "))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "?"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
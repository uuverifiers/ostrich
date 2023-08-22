;test regex ^\s{2}((A\d,|N\d,)|(A\d;|N\d;)).*\n(\s{6}.*?\n)*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.union (re.union (re.++ (re.++ (str.to_re "A") (re.range "0" "9")) (str.to_re ",")) (re.++ (re.++ (str.to_re "N") (re.range "0" "9")) (str.to_re ","))) (re.union (re.++ (str.to_re "A") (re.++ (re.range "0" "9") (str.to_re ";"))) (re.++ (str.to_re "N") (re.++ (re.range "0" "9") (str.to_re ";"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0a}") (re.* (re.++ ((_ re.loop 6 6) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
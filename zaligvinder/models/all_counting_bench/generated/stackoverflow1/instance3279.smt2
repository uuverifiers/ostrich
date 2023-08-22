;test regex "^(.*)(\d{1,4} des|de la|du [^,\s]+)(.*)$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.union (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "s"))))) (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "l") (str.to_re "a")))))) (re.++ (str.to_re "d") (re.++ (str.to_re "u") (re.++ (str.to_re " ") (re.+ (re.inter (re.diff re.allchar (str.to_re ",")) (re.inter (re.diff re.allchar (str.to_re "\u{20}")) (re.inter (re.diff re.allchar (str.to_re "\u{0b}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.diff re.allchar (str.to_re "\u{0c}"))))))))))))) (re.* (re.diff re.allchar (str.to_re "\n"))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
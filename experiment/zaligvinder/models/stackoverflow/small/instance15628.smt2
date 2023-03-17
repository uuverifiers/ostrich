;test regex ([A-Z0-9\s]+)\s*\:?\s*[\r\n]((.+[\r\n]?.*)+)[\r\n]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.opt (str.to_re ":")) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (re.++ (re.+ (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* (re.diff re.allchar (str.to_re "\n")))))) ((_ re.loop 2 2) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
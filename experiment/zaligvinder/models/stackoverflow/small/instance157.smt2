;test regex <a href="([\s]+)?([^ "\']*\.[a-zA-Z]{2,5})([\s]+)?(\.)?">([^<]*)<\/a>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "a") (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.opt (re.+ (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.++ (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re " ")) (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re "\u{27}"))))) (re.++ (str.to_re ".") ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.++ (re.opt (re.+ (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.++ (re.opt (str.to_re ".")) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ">") (re.++ (re.* (re.diff re.allchar (str.to_re "<"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (str.to_re ">"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
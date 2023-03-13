;test regex (?:&#\d{2,4};)|(\d+[\.\d]*)|(?:[a-z](?:[\u{00}-\x3B\x3D-\x7F]|<\s*[^>]+>)*)|<\s*[^>]+>
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re ";")))) (re.++ (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re ".") (re.range "0" "9"))))) (re.++ (re.range "a" "z") (re.* (re.union (re.union (re.range "\u{00}" "\u{3b}") (re.range "\u{3d}" "\u{7f}")) (re.++ (str.to_re "<") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.+ (re.diff re.allchar (str.to_re ">"))) (str.to_re ">")))))))) (re.++ (str.to_re "<") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.+ (re.diff re.allchar (str.to_re ">"))) (str.to_re ">")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
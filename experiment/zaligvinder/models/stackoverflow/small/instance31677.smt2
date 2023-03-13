;test regex ^([A-Z]{0,1})([-a-z\.']{2,30})( {1}|-{1})([A-Z]{0,1})([a-z']{0,30})( {1}|-{1})?([A-Z]{0,1})([a-z']{0,30})(( {0,1}|-{1})([A-Z]{0,1})([a-z']{0,30}))+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 1) (re.range "A" "Z")) (re.++ ((_ re.loop 2 30) (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.union (str.to_re ".") (str.to_re "\u{27}"))))) (re.++ (re.union ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 1 1) (str.to_re "-"))) (re.++ ((_ re.loop 0 1) (re.range "A" "Z")) (re.++ ((_ re.loop 0 30) (re.union (re.range "a" "z") (str.to_re "\u{27}"))) (re.++ (re.opt (re.union ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 1 1) (str.to_re "-")))) (re.++ ((_ re.loop 0 1) (re.range "A" "Z")) (re.++ ((_ re.loop 0 30) (re.union (re.range "a" "z") (str.to_re "\u{27}"))) (re.+ (re.++ (re.union ((_ re.loop 0 1) (str.to_re " ")) ((_ re.loop 1 1) (str.to_re "-"))) (re.++ ((_ re.loop 0 1) (re.range "A" "Z")) ((_ re.loop 0 30) (re.union (re.range "a" "z") (str.to_re "\u{27}"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
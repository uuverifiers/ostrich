;test regex ^([0-9/]{10}) +([0-9:]{4,5}( [AP]M)?) +(<DIR>|[0-9,]+) +([^ ]{0,11}) +(.+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 10 10) (re.union (re.range "0" "9") (str.to_re "/"))) (re.++ (re.+ (str.to_re " ")) (re.++ (re.++ ((_ re.loop 4 5) (re.union (re.range "0" "9") (str.to_re ":"))) (re.opt (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "A") (str.to_re "P")) (str.to_re "M"))))) (re.++ (re.+ (str.to_re " ")) (re.++ (re.union (re.++ (str.to_re "<") (re.++ (str.to_re "D") (re.++ (str.to_re "I") (re.++ (str.to_re "R") (str.to_re ">"))))) (re.+ (re.union (re.range "0" "9") (str.to_re ",")))) (re.++ (re.+ (str.to_re " ")) (re.++ ((_ re.loop 0 11) (re.diff re.allchar (str.to_re " "))) (re.++ (re.+ (str.to_re " ")) (re.+ (re.diff re.allchar (str.to_re "\n")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
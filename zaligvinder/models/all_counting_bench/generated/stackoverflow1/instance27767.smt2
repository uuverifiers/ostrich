;test regex (\h{8}-\h{4}-\h{4}-\h{4}-\h{12}) # match UUID
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 8 8) (str.to_re "h")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (str.to_re "h")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (str.to_re "h")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (str.to_re "h")) (re.++ (str.to_re "-") ((_ re.loop 12 12) (str.to_re "h")))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "#") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re " ") (re.++ (str.to_re "U") (re.++ (str.to_re "U") (re.++ (str.to_re "I") (str.to_re "D"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)
;test regex (\.|&#46;|(%|&#37;)(2|&#50;)([Ee]|&#69;|&#101;)){2}(/|&#47;|(%|&#37;)(2|&#50;)([Ff]|&#70;|&#102;))
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.union (str.to_re ".") (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "46") (str.to_re ";"))))) (re.++ (re.union (str.to_re "%") (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "37") (str.to_re ";"))))) (re.++ (re.union (str.to_re "2") (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "50") (str.to_re ";"))))) (re.union (re.union (re.union (str.to_re "E") (str.to_re "e")) (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "69") (str.to_re ";"))))) (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "101") (str.to_re ";"))))))))) (re.union (re.union (str.to_re "/") (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "47") (str.to_re ";"))))) (re.++ (re.union (str.to_re "%") (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "37") (str.to_re ";"))))) (re.++ (re.union (str.to_re "2") (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "50") (str.to_re ";"))))) (re.union (re.union (re.union (str.to_re "F") (str.to_re "f")) (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "70") (str.to_re ";"))))) (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "102") (str.to_re ";")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
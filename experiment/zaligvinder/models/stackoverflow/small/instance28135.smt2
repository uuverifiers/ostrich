;test regex select regexp_matches('class 1 type 1 cat 1 002267b4-ad06-11e4-89ca-59f94b49bbc0' , '\m\w{1,8}\-\w{1,4}\-\w{1,4}\-\w{1,4}\-\w{1,12}\M' )
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re "_") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "c") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "y") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "002267") (re.++ (str.to_re "b") (re.++ (str.to_re "4") (re.++ (str.to_re "-") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "06") (re.++ (str.to_re "-") (re.++ (str.to_re "11") (re.++ (str.to_re "e") (re.++ (str.to_re "4") (re.++ (str.to_re "-") (re.++ (str.to_re "89") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "-") (re.++ (str.to_re "59") (re.++ (str.to_re "f") (re.++ (str.to_re "94") (re.++ (str.to_re "b") (re.++ (str.to_re "49") (re.++ (str.to_re "b") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "0") (re.++ (str.to_re "\u{27}") (str.to_re " "))))))))))))))))))))))))))))))))))))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "m") (re.++ ((_ re.loop 1 8) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 12) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re "M") (re.++ (str.to_re "\u{27}") (str.to_re " "))))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
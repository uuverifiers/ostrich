;test regex (\d+d){0,1}[ ]*(((([0-1]){0,1}\d)|(2[0-4]))h){0,1}[ ]*(((([0-5]){0,1}[0-9])|(60))m){0,1}[ ]*(((([0-5]){0,1}[0-9])|(60))s){0,1}[ ]*
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 1) (re.++ (re.+ (re.range "0" "9")) (str.to_re "d"))) (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 0 1) (re.++ (re.union (re.++ ((_ re.loop 0 1) (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) (str.to_re "h"))) (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 0 1) (re.++ (re.union (re.++ ((_ re.loop 0 1) (re.range "0" "5")) (re.range "0" "9")) (str.to_re "60")) (str.to_re "m"))) (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 0 1) (re.++ (re.union (re.++ ((_ re.loop 0 1) (re.range "0" "5")) (re.range "0" "9")) (str.to_re "60")) (str.to_re "s"))) (re.* (str.to_re " ")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
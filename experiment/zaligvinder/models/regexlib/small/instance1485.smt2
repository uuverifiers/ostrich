;test regex ^((https?|ftp)\://((\[?(\d{1,3}\.){3}\d{1,3}\]?)|(([-a-zA-Z0-9]+\.)+[a-zA-Z]{2,4}))(\:\d+)?(/[-a-zA-Z0-9._?,&#39;+&amp;%$#=~\\]+)*/?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.opt (str.to_re "s")))))) (re.++ (str.to_re "f") (re.++ (str.to_re "t") (str.to_re "p")))) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.union (re.++ (re.opt (str.to_re "[")) (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re "]"))))) (re.++ (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "."))) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.++ (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.++ (re.* (re.++ (str.to_re "/") (re.+ (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (str.to_re "?") (re.union (str.to_re ",") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "39") (re.union (str.to_re ";") (re.union (str.to_re "+") (re.union (str.to_re "&") (re.union (str.to_re "a") (re.union (str.to_re "m") (re.union (str.to_re "p") (re.union (str.to_re ";") (re.union (str.to_re "%") (re.union (str.to_re "$") (re.union (str.to_re "#") (re.union (str.to_re "=") (re.union (str.to_re "~") (str.to_re "\\"))))))))))))))))))))))))))) (re.opt (str.to_re "/")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)
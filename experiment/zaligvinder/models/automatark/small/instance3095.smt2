(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/elections\.php\?([a-z0-9]+\u{3d}\d{1,3}\&){9}[a-z0-9]+\u{3d}\d{1,3}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//elections.php?") ((_ re.loop 9 9) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; ^(http(s?)\:\/\/)*[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&%\$#_]*)?$
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://"))) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")) (re.* (re.++ (re.* (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")))) (re.* (re.++ (str.to_re ":") (re.* (str.to_re "0-9")))) (re.opt (str.to_re "/")) (re.opt (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "_")))) (str.to_re "\u{0a}"))))
; ^(BE)[0-1]{1}[0-9]{9}$|^((BE)|(BE ))[0-1]{1}(\d{3})([.]{1})(\d{3})([.]{1})(\d{3})
(assert (str.in_re X (re.union (re.++ (str.to_re "BE") ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (re.union (str.to_re "BE") (str.to_re "BE ")) ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}f4v/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".f4v/i\u{0a}")))))
; ^([0-9]{1})([0-9]{2})([0-9]{2})([0-9]{7})([0-9]{1})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(http|https|ftp|ftps)\://([a-zA-Z0-9\-]+)(\.[a-zA-Z0-9\-]+)*(\.[a-zA-Z]{2,3})(:[0-9]*)?(/[a-zA-Z0-9_\-]*)*(\.?[a-zA-Z0-9#]{1,10})?([\?][a-zA-Z0-9\-\._\,\'\+&%\$#\=~]*)?$
(assert (str.in_re X (re.++ (re.union (str.to_re "http") (str.to_re "https") (str.to_re "ftp") (str.to_re "ftps")) (str.to_re "://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) (re.opt (re.++ (str.to_re ":") (re.* (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))))) (re.opt (re.++ (re.opt (str.to_re ".")) ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "#"))))) (re.opt (re.++ (str.to_re "?") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re ",") (str.to_re "'") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~"))))) (str.to_re "\u{0a}.") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))))))
(check-sat)

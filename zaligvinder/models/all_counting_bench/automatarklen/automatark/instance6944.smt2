(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^([0-9]+[.]+[0-9]+)|(0)$)
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.+ (re.range "0" "9")) (re.+ (str.to_re ".")) (re.+ (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}")))))
; ^(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&%\$#\=~])*$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "http") (str.to_re "https") (str.to_re "ftp")) (str.to_re "://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re ":") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re "/")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~"))) (str.to_re "\u{0a}")))))
; jar:file:/(([A-Z]:)?/([A-Z 0-9 * ( ) + \- & $ # @ _ . ! ~ /])+)(/[A-Z 0-9 _ ( ) \[ \] - = + _ ~]+\.jar!)
(assert (str.in_re X (re.++ (str.to_re "jar:file:/\u{0a}") (re.opt (re.++ (re.range "A" "Z") (str.to_re ":"))) (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (str.to_re " ") (re.range "0" "9") (str.to_re "*") (str.to_re "(") (str.to_re ")") (str.to_re "+") (str.to_re "-") (str.to_re "&") (str.to_re "$") (str.to_re "#") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re "!") (str.to_re "~") (str.to_re "/"))) (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (str.to_re " ") (re.range "0" "9") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re "[") (str.to_re "]") (re.range " " " ") (str.to_re "=") (str.to_re "+") (str.to_re "~"))) (str.to_re ".jar!"))))
; \b[1-9]\b
(assert (str.in_re X (re.++ (re.range "1" "9") (str.to_re "\u{0a}"))))
; ^[a-zA-Z_]{1}[a-zA-Z0-9_@$#]*$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "@") (str.to_re "$") (str.to_re "#"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

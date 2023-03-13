(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; jar:file:/(([A-Z]:)?/([A-Z 0-9 * ( ) + \- & $ # @ _ . ! ~ /])+)(/[A-Z 0-9 _ ( ) \[ \] - = + _ ~]+\.jar!)
(assert (not (str.in_re X (re.++ (str.to_re "jar:file:/\u{0a}") (re.opt (re.++ (re.range "A" "Z") (str.to_re ":"))) (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (str.to_re " ") (re.range "0" "9") (str.to_re "*") (str.to_re "(") (str.to_re ")") (str.to_re "+") (str.to_re "-") (str.to_re "&") (str.to_re "$") (str.to_re "#") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re "!") (str.to_re "~") (str.to_re "/"))) (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (str.to_re " ") (re.range "0" "9") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re "[") (str.to_re "]") (re.range " " " ") (str.to_re "=") (str.to_re "+") (str.to_re "~"))) (str.to_re ".jar!")))))
; [^(\&)](\w*)+(\=)[\w\d ]*
(assert (str.in_re X (re.++ (re.union (str.to_re "(") (str.to_re "&") (str.to_re ")")) (re.+ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "=") (re.* (re.union (re.range "0" "9") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; ^\$[+-]?([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(\.[0-9]{1,2})?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; WinSession\w+asdbiz\x2Ebizfrom\u{7c}roogoo\u{7c}CurrentiOpus
(assert (not (str.in_re X (re.++ (str.to_re "WinSession") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "asdbiz.bizfrom|roogoo|CurrentiOpus\u{0a}")))))
; Mirar_KeywordContent
(assert (not (str.in_re X (str.to_re "Mirar_KeywordContent\u{13}\u{0a}"))))
(check-sat)

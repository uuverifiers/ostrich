(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&%\$#\=~_\-]+))*$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "://") (re.union (re.++ (re.union (str.to_re "H") (str.to_re "h")) (re.union (str.to_re "T") (str.to_re "t"))) (str.to_re "F") (str.to_re "f")) (re.union (str.to_re "T") (str.to_re "t")) (re.union (str.to_re "P") (str.to_re "p")) (re.opt (re.union (str.to_re "S") (str.to_re "s"))))) (re.union (re.++ (str.to_re "www") re.allchar) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) re.allchar)) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re ",") (str.to_re ";") (str.to_re "?") (str.to_re "'") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "=") (str.to_re "~") (str.to_re "_") (str.to_re "-"))))) (str.to_re "\u{0a}"))))
; /\u{2f}n\.php\?h=[a-zA-Z0-9]*?\&s=[a-zA-Z0-9]{1,5}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//n.php?h=") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&s=") ((_ re.loop 1 5) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; Server\s+www\x2Epeer2mail\x2Ecom.*Subject\x3AReferer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Server") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.peer2mail.com") (re.* re.allchar) (str.to_re "Subject:Referer:\u{0a}")))))
; ^(\d){2}-(\d){2}-(\d){2}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\s+\.ico\x2FsLogearch195\.225\.Referer\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".ico/sLogearch195.225.Referer:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

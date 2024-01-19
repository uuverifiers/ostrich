(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((nntp|sftp|ftp(s)?|http(s)?|gopher|news|file|telnet):\/\/)?(([a-zA-Z0-9\._-]*([a-zA-Z0-9]\.[a-zA-Z0-9])[a-zA-Z]{1,6})|(([0-9]{1,3}\.){3}[0-9]{1,3}))(:\d+)?(\/[^:][^\s]*)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "nntp") (str.to_re "sftp") (re.++ (str.to_re "ftp") (re.opt (str.to_re "s"))) (re.++ (str.to_re "http") (re.opt (str.to_re "s"))) (str.to_re "gopher") (str.to_re "news") (str.to_re "file") (str.to_re "telnet")) (str.to_re "://"))) (re.union (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) ((_ re.loop 1 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.comp (str.to_re ":")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}"))))
; wowokay\d+FTP\s+Host\x3AFiltered\u{22}reaction\x2Etxt\u{22}
(assert (not (str.in_re X (re.++ (str.to_re "wowokay") (re.+ (re.range "0" "9")) (str.to_re "FTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Filtered\u{22}reaction.txt\u{22}\u{0a}")))))
; ^((0[1-9])|(1[0-2]))[\/\.\-]*((0[8-9])|(1[1-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.* (re.union (str.to_re "/") (str.to_re ".") (str.to_re "-"))) (re.union (re.++ (str.to_re "0") (re.range "8" "9")) (re.++ (str.to_re "1") (re.range "1" "9"))) (str.to_re "\u{0a}")))))
; .*[Pp]en[Ii1][\$s].*
(assert (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "P") (str.to_re "p")) (str.to_re "en") (re.union (str.to_re "I") (str.to_re "i") (str.to_re "1")) (re.union (str.to_re "$") (str.to_re "s")) (re.* re.allchar) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

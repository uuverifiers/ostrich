(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((nntp|sftp|ftp(s)?|http(s)?|gopher|news|file|telnet):\/\/)?(([a-zA-Z0-9\._-]*([a-zA-Z0-9]\.[a-zA-Z0-9])[a-zA-Z]{1,6})|(([0-9]{1,3}\.){3}[0-9]{1,3}))(:\d+)?(\/[^:][^\s]*)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "nntp") (str.to_re "sftp") (re.++ (str.to_re "ftp") (re.opt (str.to_re "s"))) (re.++ (str.to_re "http") (re.opt (str.to_re "s"))) (str.to_re "gopher") (str.to_re "news") (str.to_re "file") (str.to_re "telnet")) (str.to_re "://"))) (re.union (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) ((_ re.loop 1 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.comp (str.to_re ":")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}"))))
; ^(\d{4})[.](0{0,1}[1-9]|1[012])[.](0{0,1}[1-9]|[12][0-9]|3[01])[.](\d{2})$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; X-Spam-Level:\s[*]{11}
(assert (not (str.in_re X (re.++ (str.to_re "X-Spam-Level:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 11 11) (str.to_re "*")) (str.to_re "\u{0a}")))))
; ^[6]\d{7}$
(assert (not (str.in_re X (re.++ (str.to_re "6") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)

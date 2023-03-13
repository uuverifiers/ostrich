(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((nntp|sftp|ftp(s)?|http(s)?|gopher|news|file|telnet):\/\/)?(([a-zA-Z0-9\._-]*([a-zA-Z0-9]\.[a-zA-Z0-9])[a-zA-Z]{1,6})|(([0-9]{1,3}\.){3}[0-9]{1,3}))(:\d+)?(\/[^:][^\s]*)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "nntp") (str.to_re "sftp") (re.++ (str.to_re "ftp") (re.opt (str.to_re "s"))) (re.++ (str.to_re "http") (re.opt (str.to_re "s"))) (str.to_re "gopher") (str.to_re "news") (str.to_re "file") (str.to_re "telnet")) (str.to_re "://"))) (re.union (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) ((_ re.loop 1 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.comp (str.to_re ":")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}"))))
; ^([9]{1})([234789]{1})([0-9]{8})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Supreme\d+Host\x3A\d+yxegtd\u{2f}efcwgHost\x3ATPSystem
(assert (str.in_re X (re.++ (str.to_re "Supreme") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "yxegtd/efcwgHost:TPSystem\u{0a}"))))
; ^[a-zA-Z0-9\-]+\.cn$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ".cn\u{0a}")))))
(check-sat)

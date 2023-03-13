(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d*[1-9]\d*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.range "1" "9") (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Server\s+www\x2Epeer2mail\x2Ecomsubject\x3AfileId\u{3d}\u{5b}
(assert (str.in_re X (re.++ (str.to_re "Server") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.peer2mail.comsubject:fileId=[\u{0a}"))))
; 12/err
(assert (str.in_re X (str.to_re "12/err\u{0a}")))
; ^[^_.]([a-zA-Z0-9_]*[.]?[a-zA-Z0-9_]+[^_]){2}@{1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$
(assert (str.in_re X (re.++ (re.union (str.to_re "_") (str.to_re ".")) ((_ re.loop 2 2) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (re.comp (str.to_re "_")))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) (re.union ((_ re.loop 2 3) (re.range "a" "z")) (re.++ ((_ re.loop 2 3) (re.range "a" "z")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 3) (re.range "a" "z")))) (str.to_re "\u{0a}"))))
(check-sat)

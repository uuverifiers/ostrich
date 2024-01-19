(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]{1}[0-9]{3}\s{0,1}?[a-zA-Z]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; ^((((0[13578])|(1[02]))[\/]?(([0-2][0-9])|(3[01])))|(((0[469])|(11))[\/]?(([0-2][0-9])|(30)))|(02[\/]?[0-2][0-9]))[\/]?\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (re.opt (str.to_re "/")) (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (re.opt (str.to_re "/")) (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (str.to_re "30"))) (re.++ (str.to_re "02") (re.opt (str.to_re "/")) (re.range "0" "2") (re.range "0" "9"))) (re.opt (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[1-9][0-9]{0,2}$
(assert (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \u{28}\u{29}\s+WatchDog\sNetspy\d+pjpoptwql\u{2f}rlnjX-Mailer\u{3a}Host\u{3a}snprtz\x7Cdialnoref\x3D\u{25}user\x5Fid
(assert (str.in_re X (re.++ (str.to_re "()") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDog") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Netspy") (re.+ (re.range "0" "9")) (str.to_re "pjpoptwql/rlnjX-Mailer:\u{13}Host:snprtz|dialnoref=%user_id\u{0a}"))))
; ^((.){1,}(\d){1,}(.){0,})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ re.allchar) (re.+ (re.range "0" "9")) (re.* re.allchar)))))
(assert (> (str.len X) 10))
(check-sat)

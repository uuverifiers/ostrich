(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1,})$|^(\d{1,}\.)$|^(\d{0,}?\.\d{1,})$|^([+-]\d{1,}(\.)?)$|^([+-](\d{1,})?\.\d{1,})$
(assert (str.in_re X (re.union (re.+ (re.range "0" "9")) (re.++ (re.+ (re.range "0" "9")) (str.to_re ".")) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (re.union (str.to_re "+") (str.to_re "-")) (re.+ (re.range "0" "9")) (re.opt (str.to_re "."))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "+") (str.to_re "-")) (re.opt (re.+ (re.range "0" "9"))) (str.to_re ".") (re.+ (re.range "0" "9"))))))
; \u{28}\u{29}\s+WatchDog\sNetspy\d+pjpoptwql\u{2f}rlnjX-Mailer\u{3a}Host\u{3a}snprtz\x7Cdialnoref\x3D\u{25}user\x5Fid
(assert (str.in_re X (re.++ (str.to_re "()") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDog") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Netspy") (re.+ (re.range "0" "9")) (str.to_re "pjpoptwql/rlnjX-Mailer:\u{13}Host:snprtz|dialnoref=%user_id\u{0a}"))))
; ^([A-Za-z]{5})([0-9]{4})([A-Za-z]{1})$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; ^[-]?\d*(\.\d*)$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}.") (re.* (re.range "0" "9")))))
; /\u{2e}msi([\?\u{5c}\u{2f}]|$)/miU
(assert (not (str.in_re X (re.++ (str.to_re "/.msi") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/miU\u{0a}")))))
(check-sat)

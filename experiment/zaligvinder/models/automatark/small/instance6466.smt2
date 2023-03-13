(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Toolbar[^\n\r]*User-Agent\x3A\w+Host\x3A.*toX-Mailer\u{3a}Logsmax-Cookie\u{3a}AppName
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "toX-Mailer:\u{13}Logsmax-Cookie:AppName\u{0a}"))))
; /\/java(rh|db)\.php$/U
(assert (str.in_re X (re.++ (str.to_re "//java") (re.union (str.to_re "rh") (str.to_re "db")) (str.to_re ".php/U\u{0a}"))))
; ^[A-z]?\d{8}[A-z]$
(assert (not (str.in_re X (re.++ (re.opt (re.range "A" "z")) ((_ re.loop 8 8) (re.range "0" "9")) (re.range "A" "z") (str.to_re "\u{0a}")))))
; ^([1-9]|1[0-2]|0[1-9]){1}(:[0-5][0-9][ ][aApP][mM]){1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9")))) ((_ re.loop 1 1) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re " ") (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")))) (str.to_re "\u{0a}"))))
(check-sat)

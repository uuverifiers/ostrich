(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-2]{0,1})([0-3]{1})(\.[0-9]{1,2})?$|^([0-1]{0,1})([0-9]{1})(\.[0-9]{1,2})?$|^-?(24)(\.[0]{1,2})?$|^([0-9]{1})(\.[0-9]{1,2})?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "3")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.opt (str.to_re "-")) (str.to_re "24") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(\d|,)*\d*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ([0-9]+)\s(d)\s(([0-1][0-9])|([2][0-3])):([0-5][0-9]):([0-5][0-9])
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "d") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9")))))
; Toolbar[^\n\r]*User-Agent\x3A\w+Host\x3A.*toX-Mailer\u{3a}Logsmax-Cookie\u{3a}AppName
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "toX-Mailer:\u{13}Logsmax-Cookie:AppName\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

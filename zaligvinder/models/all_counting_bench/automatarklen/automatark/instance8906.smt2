(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\u{3a}\s+sErver\s+-~-GREATHost\u{3a}
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "sErver") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-~-GREATHost:\u{0a}"))))
; Toolbar[^\n\r]*User-Agent\x3A\w+Host\x3A.*toX-Mailer\u{3a}Logsmax-Cookie\u{3a}AppName
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "toX-Mailer:\u{13}Logsmax-Cookie:AppName\u{0a}"))))
; ^(6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d{3}|[1-5]\d{4}|[1-9]\d{0,3}|0)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "65") (re.range "0" "4") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}")))))
; ^\{?[a-fA-F\d]{32}\}?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "{")) ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (re.opt (str.to_re "}")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

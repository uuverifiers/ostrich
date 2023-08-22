(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\s*[a-zA-Z,\s]+\s*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; at\w+Pre\s+adfsgecoiwnfhirmvtg\u{2f}ggqh\.kqhSurveillanceHost\x3A
(assert (str.in_re X (re.++ (str.to_re "at") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}Surveillance\u{13}Host:\u{0a}"))))
; Toolbar[^\n\r]*User-Agent\x3A\w+Host\x3A.*toX-Mailer\u{3a}Logsmax-Cookie\u{3a}AppName
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "toX-Mailer:\u{13}Logsmax-Cookie:AppName\u{0a}"))))
; /\/[a-z]{4}\.html\?j\=\d{6,7}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?j=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

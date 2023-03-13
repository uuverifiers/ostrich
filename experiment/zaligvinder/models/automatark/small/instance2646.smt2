(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; \.fcgi[^\n\r]*Host\x3A\s\x5D\u{25}20\x5BPort_NETObserveTM_SEARCH3
(assert (not (str.in_re X (re.++ (str.to_re ".fcgi") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "]%20[Port_NETObserveTM_SEARCH3\u{0a}")))))
; BysooTBwhenu\x2EcomToolbarWeAgentUser-Agent\u{3a}hasHost\u{3a}toWebupdate\.cgithis
(assert (not (str.in_re X (str.to_re "BysooTBwhenu.com\u{1b}ToolbarWeAgentUser-Agent:hasHost:toWebupdate.cgithis\u{0a}"))))
; X-Mailer\x3AisSubject\u{3a}
(assert (not (str.in_re X (str.to_re "X-Mailer:\u{13}isSubject:\u{0a}"))))
; ^(\d){2}-(\d){2}-(\d){2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)

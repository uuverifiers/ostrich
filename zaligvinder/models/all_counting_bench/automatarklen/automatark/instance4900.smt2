(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; cojud\x2Edmcast\x2EcomAgentHost\x3Ainsertkeys\x3Ckeys\u{40}hotpop
(assert (not (str.in_re X (str.to_re "cojud.dmcast.comAgentHost:insertkeys<keys@hotpop\u{0a}"))))
; toolbarplace\x2Ecom[^\n\r]*Server[^\n\r]*X-Mailer\u{3a}\sUser-Agent\u{3a}Host\x3ABar\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (re.++ (str.to_re "toolbarplace.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Server") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:Host:Bar/newsurfer4/\u{0a}")))))
; dll\x3Fbadurl\x2Egrandstreetinteractive\x2Ecom
(assert (not (str.in_re X (str.to_re "dll?badurl.grandstreetinteractive.com\u{0a}"))))
; /\u{0d}\u{0a}Host\u{3a}\u{20}[^\u{0d}\u{0a}\u{2e}]+\u{2e}[^\u{0d}\u{0a}\u{2e}]+(\u{3a}\d{1,5})?\u{0d}\u{0a}\u{0d}\u{0a}$/H
(assert (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Host: ") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "."))) (str.to_re ".") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "."))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0d}\u{0a}\u{0d}\u{0a}/H\u{0a}"))))
; ([a-zA-Z0-9\_\-\.]+[a-zA-Z0-9\_\-\.]+[a-zA-Z0-9\_\-\.]+)+@([a-zA-z0-9][a-zA-z0-9][a-zA-z0-9]*)+(\.[a-zA-z0-9][a-zA-z0-9][a-zA-z0-9]*)(\.[a-zA-z0-9]+)*
(assert (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))))) (str.to_re "@") (re.+ (re.++ (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))))) (str.to_re "\u{0a}.") (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)

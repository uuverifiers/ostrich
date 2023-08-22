(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; welcomeforToolbarHost\x3A
(assert (not (str.in_re X (str.to_re "welcomeforToolbarHost:\u{0a}"))))
; \b([0-1]?\d{1,2}|2[0-4]\d|25[0-5])(\.([0-1]?\d{1,2}|2[0-4]\d|25[0-5])){3}\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) ((_ re.loop 3 3) (re.++ (str.to_re ".") (re.union (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))))) (str.to_re "\u{0a}")))))
; Host\x3A\s+Agentbody=\u{25}21\u{25}21\u{25}21Optix
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Agentbody=%21%21%21Optix\u{13}\u{0a}"))))
; on\dName=Your\+Host\+is\x3AcdpViewHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "on") (re.range "0" "9") (str.to_re "Name=Your+Host+is:cdpViewHost:User-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; X-Mailer\u{3a}User-Agent\x3A
(assert (not (str.in_re X (str.to_re "X-Mailer:\u{13}User-Agent:\u{0a}"))))
; HWAE[^\n\r]*Email[^\n\r]*User-Agent\x3AUser-Agent\u{3a}wowokayHost\x3A
(assert (str.in_re X (re.++ (str.to_re "HWAE") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Email") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:User-Agent:wowokayHost:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

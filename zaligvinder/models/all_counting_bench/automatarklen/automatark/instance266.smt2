(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}SoftwareHost\x3AjokeWEBCAM-Server\u{3a}
(assert (str.in_re X (str.to_re "Host:SoftwareHost:jokeWEBCAM-Server:\u{0a}")))
; ^[A-Za-z]{2}[ ]{0,1}[0-9]{2}[ ]{0,1}[a-zA-Z]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; /\u{00}hide hide\u{22}\u{09}\u{22}([a-z0-9\u{5c}\u{2e}\u{3a}]+\u{2e}exe|sh)/
(assert (str.in_re X (re.++ (str.to_re "/\u{00}hide hide\u{22}\u{09}\u{22}") (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "\u{5c}") (str.to_re ".") (str.to_re ":"))) (str.to_re ".exe")) (str.to_re "sh")) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

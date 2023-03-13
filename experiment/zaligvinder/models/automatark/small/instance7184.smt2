(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /onload\s*\x3D\s*[\u{22}\u{27}]?location\.reload\s*\u{28}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/onload") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "location.reload") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(/smi\u{0a}")))))
; this\s+MyBrowser\d+Redirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowser") (re.+ (re.range "0" "9")) (str.to_re "Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}"))))
; PORT\x3D\s+User-Agent\x3A\s+ProAgentUI2Host\x3A00000www\x2Ezhongsou\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "PORT=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ProAgentUI2Host:00000www.zhongsou.com\u{0a}")))))
; ^(([0-9]{5})|([0-9]{3}[ ]{0,1}[0-9]{2}))$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^[a-zA-Z]\w{3,14}$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 3 14) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(check-sat)

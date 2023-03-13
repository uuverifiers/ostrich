(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; this\s+MyBrowser\d+Redirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowser") (re.+ (re.range "0" "9")) (str.to_re "Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}"))))
; /<linearGradient[^>]*>\s*<\u{2f}linearGradient>/i
(assert (str.in_re X (re.++ (str.to_re "/<linearGradient") (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "</linearGradient>/i\u{0a}"))))
; \$?GP[a-z]{3,},([a-z0-9\.]*,)+([a-z0-9]{1,2}\*[a-z0-9]{1,2})
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (str.to_re "GP,") (re.+ (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "."))) (str.to_re ","))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "a" "z")) (re.* (re.range "a" "z")) ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "*") ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9")))))))
; Host\x3A\sHello\x2E.*forum=
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Hello.") (re.* re.allchar) (str.to_re "forum=\u{0a}"))))
(check-sat)

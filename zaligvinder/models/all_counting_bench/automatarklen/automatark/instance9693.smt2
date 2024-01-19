(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Server\s+www\x2Epeer2mail\x2Ecom.*Subject\x3AReferer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Server") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.peer2mail.com") (re.* re.allchar) (str.to_re "Subject:Referer:\u{0a}")))))
; ^((([0]?[1-9]|1[0-2])(:|\.)(00|15|30|45)?( )?(AM|am|aM|Am|PM|pm|pM|Pm))|(([0]?[0-9]|1[0-9]|2[0-3])(:|\.)(00|15|30|45)?))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ":") (str.to_re ".")) (re.opt (re.union (str.to_re "00") (str.to_re "15") (str.to_re "30") (str.to_re "45"))) (re.opt (str.to_re " ")) (re.union (str.to_re "AM") (str.to_re "am") (str.to_re "aM") (str.to_re "Am") (str.to_re "PM") (str.to_re "pm") (str.to_re "pM") (str.to_re "Pm"))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.union (str.to_re ":") (str.to_re ".")) (re.opt (re.union (str.to_re "00") (str.to_re "15") (str.to_re "30") (str.to_re "45"))))) (str.to_re "\u{0a}")))))
; /^\/f(\/[^\u{2f}]+)?\/14\d{8}(\/\d{9,10})?(\/\d)+(\/x[a-f0-9]+(\u{3b}\d)+?)?$/U
(assert (str.in_re X (re.++ (str.to_re "//f") (re.opt (re.++ (str.to_re "/") (re.+ (re.comp (str.to_re "/"))))) (str.to_re "/14") ((_ re.loop 8 8) (re.range "0" "9")) (re.opt (re.++ (str.to_re "/") ((_ re.loop 9 10) (re.range "0" "9")))) (re.+ (re.++ (str.to_re "/") (re.range "0" "9"))) (re.opt (re.++ (str.to_re "/x") (re.+ (re.union (re.range "a" "f") (re.range "0" "9"))) (re.+ (re.++ (str.to_re ";") (re.range "0" "9"))))) (str.to_re "/U\u{0a}"))))
; Supreme\s+User-Agent\x3A\s+ApofisToolbarUser
(assert (not (str.in_re X (re.++ (str.to_re "Supreme") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ApofisToolbarUser\u{0a}")))))
; /^tcpdata\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/tcpdata|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

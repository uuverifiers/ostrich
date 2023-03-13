(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Supreme\s+User-Agent\x3A\s+ApofisToolbarUser
(assert (not (str.in_re X (re.++ (str.to_re "Supreme") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ApofisToolbarUser\u{0a}")))))
; \.myway\.comToolbarUI2Host\x3ASubject\x3Atoxbqyosoe\u{2f}cpvm
(assert (not (str.in_re X (str.to_re ".myway.com\u{1b}ToolbarUI2Host:Subject:toxbqyosoe/cpvm\u{0a}"))))
; ver.*Black\s+CD\x2Furl=Host\u{3a}notification
(assert (not (str.in_re X (re.++ (str.to_re "ver") (re.* re.allchar) (str.to_re "Black") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "CD/url=Host:notification\u{13}\u{0a}")))))
; /[^\u{20}-\u{7e}\u{0d}\u{0a}]{4}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}"))))
; ^(\d{3,})\s?(\w{0,5})\s([a-zA-Z]{2,30})\s([a-zA-Z]{2,15})\.?\s?(\w{0,5})$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 5) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 30) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 15) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 5) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (re.* (re.range "0" "9")))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\w\W]{1,1500}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1500) (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; \\[\\w{2}\\]
(assert (str.in_re X (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{5c}") (str.to_re "w") (str.to_re "{") (str.to_re "2") (str.to_re "}")) (str.to_re "\u{0a}"))))
; connection\sHost\u{3a}Subject\x3A\.bmp
(assert (str.in_re X (re.++ (str.to_re "connection") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:Subject:.bmp\u{0a}"))))
; /[^\u{20}-\u{7e}\r\n]{3}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}"))))
; /\u{2e}exe([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.exe") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[ABCGHJMPQRTWXYZ]$
(assert (str.in_re X (re.++ (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "M") (str.to_re "P") (str.to_re "Q") (str.to_re "R") (str.to_re "T") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z")) (str.to_re "\u{0a}"))))
; emailFrom\x3AUser-Agent\x3AUser-Agent\x3Aselect\x2FGet
(assert (not (str.in_re X (str.to_re "emailFrom:User-Agent:User-Agent:select/Get\u{0a}"))))
; /\/[a-f0-9]{32}\/[a-f0-9]{32}\u{22}/R
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{22}/R\u{0a}")))))
; /^[1-9][0-9][0-9][0-9][0-9][0-9]$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "1" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re "/\u{0a}"))))
; Host\s+pjpoptwql\u{2f}rlnjSubject\x3A
(assert (str.in_re X (re.++ (str.to_re "Host") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "pjpoptwql/rlnjSubject:\u{0a}"))))
(check-sat)

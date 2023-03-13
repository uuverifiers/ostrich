(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; from\x3AUser-Agent\x3AChildWebGuardian
(assert (str.in_re X (str.to_re "from:User-Agent:ChildWebGuardian\u{0a}")))
; ^[a-zA-Z]{3}[uU]{1}[0-9]{7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.union (str.to_re "u") (str.to_re "U"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[a-zA-Z_][a-zA-Z0-9_]*$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; <title>+(.*?)</title>
(assert (not (str.in_re X (re.++ (str.to_re "<title") (re.+ (str.to_re ">")) (re.* re.allchar) (str.to_re "</title>\u{0a}")))))
(check-sat)

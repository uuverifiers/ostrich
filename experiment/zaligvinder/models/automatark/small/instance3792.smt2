(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <.*\b(bgcolor\s*=\s*[\"|\']*(\#\w{6})[\"|\']*).*>
(assert (str.in_re X (re.++ (str.to_re "<") (re.* re.allchar) (re.* re.allchar) (str.to_re ">\u{0a}bgcolor") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "|") (str.to_re "'"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "|") (str.to_re "'"))) (str.to_re "#") ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; Software\s+User-Agent\x3A.*FictionalUser-Agent\x3AUser-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Software") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "FictionalUser-Agent:User-Agent:\u{0a}"))))
; /[^\u{20}-\u{7e}\r\n]{3}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}")))))
(check-sat)

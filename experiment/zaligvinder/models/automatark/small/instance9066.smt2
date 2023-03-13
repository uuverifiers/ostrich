(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [A-Z][a-zA-Z]+ [A-Z][a-zA-Z]+
(assert (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re " ") (re.range "A" "Z") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; URLBlaze.*User-Agent\x3A.*mPOPUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "URLBlaze") (re.* re.allchar) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "mPOPUser-Agent:\u{0a}")))))
; 666Host\u{3a}WEBCAM-Host\u{3a}
(assert (not (str.in_re X (str.to_re "666Host:WEBCAM-Host:\u{0a}"))))
; [\s0-9a-zA-Z\;\"\,\<\>\\?\+\=\)\(\\*\&\%\\$\#\.]*
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re ";") (str.to_re "\u{22}") (str.to_re ",") (str.to_re "<") (str.to_re ">") (str.to_re "\u{5c}") (str.to_re "?") (str.to_re "+") (str.to_re "=") (str.to_re ")") (str.to_re "(") (str.to_re "*") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^\d{1,7}$
(assert (str.in_re X (re.++ ((_ re.loop 1 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)

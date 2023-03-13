(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{5f}\w{24}\.exe/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/_") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".exe/Pi\u{0a}")))))
; [A-Z][a-zA-Z]+ [A-Z][a-zA-Z]+
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re " ") (re.range "A" "Z") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
(check-sat)

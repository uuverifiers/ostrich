(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}hhk([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.hhk") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; [0-9]{4}[A-Z]{2}
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; www\x2Emaxifiles\x2EcomServidor\x2E
(assert (not (str.in_re X (str.to_re "www.maxifiles.comServidor.\u{13}\u{0a}"))))
; /^connect\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/connect|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; \\[\\w{2}\\]
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{5c}") (str.to_re "w") (str.to_re "{") (str.to_re "2") (str.to_re "}")) (str.to_re "\u{0a}")))))
(check-sat)

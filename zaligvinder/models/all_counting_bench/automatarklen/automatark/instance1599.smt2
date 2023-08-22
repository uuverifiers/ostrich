(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AWordmyway\.comhoroscope2Host
(assert (not (str.in_re X (str.to_re "Host:Wordmyway.comhoroscope2Host\u{0a}"))))
; ^[0-9#\*abcdABCD]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re "#") (str.to_re "*") (str.to_re "a") (str.to_re "b") (str.to_re "c") (str.to_re "d") (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "D"))) (str.to_re "\u{0a}")))))
; ^\d{4,4}[A-Z0-9](, *\d{4,4})[A-Z0-9]*$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "0" "9")) (re.* (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a},") (re.* (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")))))
; SecureNet.*\x2Fsearchfast\x2F
(assert (str.in_re X (re.++ (str.to_re "SecureNet") (re.* re.allchar) (str.to_re "/searchfast/\u{0a}"))))
; /\u{2e}plp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.plp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

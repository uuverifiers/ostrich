(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Guarded\s+ready\w+PARSERHost\u{3a}A-311ServerUser-Agent\x3Ascn\u{2e}mystoretoolbar\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "Guarded") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ready") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "PARSERHost:A-311ServerUser-Agent:scn.mystoretoolbar.com\u{13}\u{0a}"))))
; PromulGate\s+SbAts.*Uservclxatmlhavj\u{2f}vsywww\x2Evip-se\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "PromulGate") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SbAts") (re.* re.allchar) (str.to_re "Uservclxatmlhavj/vsywww.vip-se.com\u{13}\u{0a}"))))
; (:[a-z]{1}[a-z1-9\$#_]*){1,31}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 31) (re.++ (str.to_re ":") ((_ re.loop 1 1) (re.range "a" "z")) (re.* (re.union (re.range "a" "z") (re.range "1" "9") (str.to_re "$") (str.to_re "#") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; /\/[a-z]{4}\.html\?i\=\d{6,7}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?i=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

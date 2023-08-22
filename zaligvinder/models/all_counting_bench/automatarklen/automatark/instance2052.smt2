(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((0|1[0-9]{0,2}|2[0-9]?|2[0-4][0-9]|25[0-5]|[3-9][0-9]?)\.){3}(0|1[0-9]{0,2}|2[0-9]?|2[0-4][0-9]|25[0-5]|[3-9][0-9]?)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (str.to_re "0") (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "3" "9") (re.opt (re.range "0" "9")))) (str.to_re "."))) (re.union (str.to_re "0") (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "3" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; www\x2Eweepee\x2Ecom\w+Owner\x3Aiswww\x2Eemp3finder\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:iswww.emp3finder.com\u{0a}")))))
; /\/3\/[A-Z]{2}\/[a-f0-9]{32}\/\d+\.\d+\.\d+\.\d+\//
(assert (not (str.in_re X (re.++ (str.to_re "//3/") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "//\u{0a}")))))
; /\u{2e}msi([\?\u{5c}\u{2f}]|$)/miU
(assert (not (str.in_re X (re.++ (str.to_re "/.msi") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/miU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

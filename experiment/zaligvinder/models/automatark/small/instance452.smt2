(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\dName=Your\+Host\+is\x3A.*has\s+ComputerKeylogger\x2EcomHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Name=Your+Host+is:") (re.* re.allchar) (str.to_re "has") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ComputerKeylogger.comHost:\u{0a}")))))
; ^[0-9]*\/{1}[1-9]{1}[0-9]*$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "/")) ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[^\u{00}-\u{1f}\u{21}-\u{26}\u{28}-\u{2d}\u{2f}-\u{40}\u{5b}-\u{60}\u{7b}-\u{ff}]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "\u{00}" "\u{1f}") (re.range "!" "&") (re.range "(" "-") (re.range "/" "@") (re.range "[" "`") (re.range "{" "\u{ff}"))) (str.to_re "\u{0a}")))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]\d{0,3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "65") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "6553") (re.range "0" "5"))) (str.to_re "\u{0a}")))))
; devSoft\u{27}s\s+Host\x3A\s+Host\x3A
(assert (str.in_re X (re.++ (str.to_re "devSoft's\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; User-Agent\x3ASurveillancecomOnline
(assert (not (str.in_re X (str.to_re "User-Agent:Surveillance\u{13}comOnline\u{0a}"))))
; User-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
; ^(0{0,1}[1-9]|[12][0-9]|3[01])[- /.](0{0,1}[1-9]|1[012])[- /.](\d{2}|\d{4})$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "/") (str.to_re ".")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "/") (str.to_re ".")) (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

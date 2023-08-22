(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{3}-\d{7}[0-6]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "6")) (str.to_re "\u{0a}"))))
; ^\w+.*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar) (str.to_re "\u{0a}")))))
; User-Agent\u{3a}\w+Owner\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:\u{0a}")))))
; ^([1-9]|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

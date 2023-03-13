(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1-9]{1}[0-9]{0,5}([.]{1}[0-9]{0,2})?)|(([0]{1}))([.]{1}[0-9]{0,2})?)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (str.to_re "0")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 0 2) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; EFError.*Host\x3A\swww\u{2e}malware-stopper\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "EFError") (re.* re.allchar) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.malware-stopper.com\u{0a}"))))
; ^([A-HJ-TP-Z]{1}\d{4}[A-Z]{3}|[a-z]{1}\d{4}[a-hj-tp-z]{3})$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "H") (re.range "J" "T") (re.range "P" "Z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "A" "Z"))) (re.++ ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "a" "h") (re.range "j" "t") (re.range "p" "z"))))) (str.to_re "\u{0a}")))))
(check-sat)

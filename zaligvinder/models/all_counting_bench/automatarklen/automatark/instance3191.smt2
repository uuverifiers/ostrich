(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^.*(yourdomain.com).*$
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.* re.allchar) (str.to_re "\u{0a}yourdomain") re.allchar (str.to_re "com")))))
; (^\d{5}\x2D\d{3}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")))))
; ^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))+(.pdf)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (re.++ (re.opt (str.to_re "$")) ((_ re.loop 2 2) (str.to_re "\u{5c}")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.+ (re.++ (str.to_re "\u{5c}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* re.allchar))) (str.to_re "\u{0a}") re.allchar (str.to_re "pdf")))))
; /\*.+?\*/
(assert (not (str.in_re X (re.++ (str.to_re "/*") (re.+ re.allchar) (str.to_re "*/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]{1}[0-9]{3}\s?[A-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; ("((\\.)|[^\\"])*")
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (str.to_re "\u{5c}") (str.to_re "\u{22}"))) (str.to_re "\u{22}")))))
; Logger\w+gdvsotuqwsg\u{2f}dxt\.hd\dovpl\dHOST\x3AUser-Agent\x3AURLUBAgent%3fSchwindlerurl=Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Logger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "gdvsotuqwsg/dxt.hd") (re.range "0" "9") (str.to_re "ovpl") (re.range "0" "9") (str.to_re "HOST:User-Agent:URLUBAgent%3fSchwindlerurl=Host:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

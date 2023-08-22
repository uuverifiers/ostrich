(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /counter.img\?theme\=\d+\&digits\=10\&siteId\=\d+$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/counter") re.allchar (str.to_re "img?theme=") (re.+ (re.range "0" "9")) (str.to_re "&digits=10&siteId=") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; ^\d{1,3}\.\d{1,4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

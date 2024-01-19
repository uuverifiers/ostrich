(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /counter.img\?theme\=\d+\&digits\=10\&siteId\=\d+$/Ui
(assert (str.in_re X (re.++ (str.to_re "/counter") re.allchar (str.to_re "img?theme=") (re.+ (re.range "0" "9")) (str.to_re "&digits=10&siteId=") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; /^\/\d\u{2e}exe/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.range "0" "9") (str.to_re ".exe/Ui\u{0a}")))))
; ^[A-Z]{1}( |-)?[1-9]{1}[0-9]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

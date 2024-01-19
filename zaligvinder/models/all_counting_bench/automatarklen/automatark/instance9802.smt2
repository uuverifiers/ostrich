(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-zA-Z0-9]{32}\.jar/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}"))))
; ^rgb\(([01]?\d\d?|2[0-4]\d|25[0-5])\,([01]?\d\d?|2[0-4]\d|25[0-5])\,([01]?\d\d?|2[0-4]\d|25[0-5])\)$ #Matches standard web rgb pattern
(assert (str.in_re X (re.++ (str.to_re "rgb(") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ",") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ",") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ") #Matches standard web rgb pattern\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

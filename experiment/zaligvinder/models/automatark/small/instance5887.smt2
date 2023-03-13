(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^0.*[1-9]*)|(^860+)|(^8613)|(\D)|([0-9])
(assert (str.in_re X (re.union (re.++ (str.to_re "0") (re.* re.allchar) (re.* (re.range "1" "9"))) (re.++ (str.to_re "86") (re.+ (str.to_re "0"))) (str.to_re "8613") (re.comp (re.range "0" "9")) (re.++ (re.range "0" "9") (str.to_re "\u{0a}")))))
; phpinfo[^\n\r]*195\.225\.\dccecaedbebfcaf\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "phpinfo") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "195.225.") (re.range "0" "9") (str.to_re "ccecaedbebfcaf.com\u{0a}")))))
; IP.*encoder\d+SAHPORT-User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "IP") (re.* re.allchar) (str.to_re "encoder") (re.+ (re.range "0" "9")) (str.to_re "SAHPORT-User-Agent:\u{0a}"))))
; /^\/[a-z]{5}\.php\?id=0\d{5}111D30[a-zA-Z0-9]{6}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.range "a" "z")) (str.to_re ".php?id=0") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "111D30") ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}")))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{28}\u{29}\s+WatchDog\sNetspyt=WeHost\x3A\x2Fcgi\x2Flogurl\.cgiwww\x2Ekliksearch\x2Ecom1\x2E3\x7D\x7BTrojan\x3A
(assert (str.in_re X (re.++ (str.to_re "()") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDog") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Netspyt=WeHost:/cgi/logurl.cgiwww.kliksearch.com1.3}{Trojan:\u{0a}"))))
; /^\/[a-f0-9]{32}\/[a-f0-9]{32}\.jar$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".jar/Ui\u{0a}")))))
; ^\d{1,2}\/\d{2,4}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([A-Z][a-z]+)\s([A-Z][a-zA-Z-]+)$
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}") (re.range "A" "Z") (re.+ (re.range "a" "z")) (re.range "A" "Z") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "-"))))))
(assert (> (str.len X) 10))
(check-sat)

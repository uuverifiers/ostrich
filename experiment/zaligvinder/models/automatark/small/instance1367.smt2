(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /&q=[a-f0-9]{32},[a-f0-9]{16}&kgs=/U
(assert (not (str.in_re X (re.++ (str.to_re "/&q=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&kgs=/U\u{0a}")))))
; /\/[a-z]+\?[a-z]+\=[a-z]+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "a" "z")) (str.to_re "?") (re.+ (re.range "a" "z")) (str.to_re "=") (re.+ (re.range "a" "z")) (str.to_re "/U\u{0a}")))))
; \u{28}\u{29}\s+WatchDog\sNetspyt=WeHost\x3A\x2Fcgi\x2Flogurl\.cgiwww\x2Ekliksearch\x2Ecom1\x2E3\x7D\x7BTrojan\x3A
(assert (not (str.in_re X (re.++ (str.to_re "()") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDog") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Netspyt=WeHost:/cgi/logurl.cgiwww.kliksearch.com1.3}{Trojan:\u{0a}")))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; media\x2Edxcdirect\x2Ecom\.smx\?PASSW=SAHHost\x3AProAgentIDENTIFY
(assert (str.in_re X (str.to_re "media.dxcdirect.com.smx?PASSW=SAHHost:ProAgentIDENTIFY\u{0a}")))
; \u{28}\u{29}\s+WatchDog\sNetspyt=WeHost\x3A\x2Fcgi\x2Flogurl\.cgiwww\x2Ekliksearch\x2Ecom1\x2E3\x7D\x7BTrojan\x3A
(assert (not (str.in_re X (re.++ (str.to_re "()") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDog") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Netspyt=WeHost:/cgi/logurl.cgiwww.kliksearch.com1.3}{Trojan:\u{0a}")))))
; /^\/0[a-z]{0,13}[0-9]{0,12}[a-z][a-z0-9]{1,11}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//0") ((_ re.loop 0 13) (re.range "a" "z")) ((_ re.loop 0 12) (re.range "0" "9")) (re.range "a" "z") ((_ re.loop 1 11) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(check-sat)

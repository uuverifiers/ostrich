(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\x2F40e800[0-9A-F]{30,}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//40e800/Ui\u{0a}") ((_ re.loop 30 30) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F"))))))
; LIST\]SpamBlockerUtilityTry2FindBasicHost\x3AUser-Agent\x3AAcmeprotocolSpy
(assert (not (str.in_re X (str.to_re "LIST]SpamBlockerUtilityTry2FindBasicHost:User-Agent:AcmeprotocolSpy\u{0a}"))))
; (^\d{3,5}\,\d{2}$)|(^\d{3,5}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; /\/[a-z]{2}\/testcon.php$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "/testcon") re.allchar (str.to_re "php/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

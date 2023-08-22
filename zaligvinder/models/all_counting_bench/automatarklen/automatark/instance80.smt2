(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^UA-\d+-\d+$
(assert (str.in_re X (re.++ (str.to_re "UA-") (re.+ (re.range "0" "9")) (str.to_re "-") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^([0-2]\d\d){75}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 75 75) (re.++ (re.range "0" "2") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "/P\u{0a}"))))
; /\/feed\.dll\?pub_id=\d+?\&ua=/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//feed.dll?pub_id=") (re.+ (re.range "0" "9")) (str.to_re "&ua=/Ui\u{0a}")))))
; /filename=[^\n]*\u{2e}rdp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rdp/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

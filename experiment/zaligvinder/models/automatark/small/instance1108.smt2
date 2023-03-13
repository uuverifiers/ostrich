(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{2}-[0-9]{8}-[0-9]$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
; /^\/\d+$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; whenu\x2Ecom\d+Agent\stoWebupdate\.cgithisHost\u{3a}connection
(assert (not (str.in_re X (re.++ (str.to_re "whenu.com\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "Agent") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toWebupdate.cgithisHost:connection\u{0a}")))))
; /filename=[^\n]*\u{2e}rjs/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rjs/i\u{0a}")))))
(check-sat)

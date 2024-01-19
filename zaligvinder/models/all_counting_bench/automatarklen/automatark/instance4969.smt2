(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/AES\d{9}O\d{4,5}\u{2e}jsp/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//AES") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "O") ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re ".jsp/Ui\u{0a}")))))
; /filename=[^\n]*\u{2e}amf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".amf/i\u{0a}")))))
; ovplSubject\x3ATencentTravelerClient\x7D\x7BSysuptime\x3A
(assert (str.in_re X (str.to_re "ovplSubject:TencentTravelerClient}{Sysuptime:\u{0a}")))
; ^\s*[a-zA-Z0-9,\s]+\s*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+86)(13[0-9]|145|147|15[0-3,5-9]|18[0,2,5-9])(\d{8})$
(assert (not (str.in_re X (re.++ (str.to_re "+86") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}1") (re.union (re.++ (str.to_re "3") (re.range "0" "9")) (str.to_re "45") (str.to_re "47") (re.++ (str.to_re "5") (re.union (re.range "0" "3") (str.to_re ",") (re.range "5" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "2") (re.range "5" "9"))))))))
; /filename=[^\n]*\u{2e}wal/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wal/i\u{0a}")))))
; Web-Mail\dHost\x3AHost\x3ALOG
(assert (str.in_re X (re.++ (str.to_re "Web-Mail") (re.range "0" "9") (str.to_re "Host:Host:LOG\u{0a}"))))
; /filename=[^\n]*\u{2e}plp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".plp/i\u{0a}"))))
; 3A\s+URLBlazeHost\x3Atrackhjhgquqssq\u{2f}pjm
(assert (str.in_re X (re.++ (str.to_re "3A") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlazeHost:trackhjhgquqssq/pjm\u{0a}"))))
(check-sat)

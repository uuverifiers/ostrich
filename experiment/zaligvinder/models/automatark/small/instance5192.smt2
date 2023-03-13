(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; UBAgentwhenu\x2Ecomwp-includes\x2Ffeed\x2Ephp\x3F
(assert (str.in_re X (str.to_re "UBAgentwhenu.com\u{13}wp-includes/feed.php?\u{0a}")))
; /filename\s*=\s*[^\r\n]*?\u{2e}swf[\u{22}\u{27}\u{3b}\s\r\n]/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ".swf") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ";") (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/i\u{0a}")))))
; ([A-Za-z]{2}|[A-Za-z]\d|\d[A-Za-z])[A-Za-z]{0,1}\d(\d{0,3})[A-Za-z]{0,1}
(assert (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9")) (re.++ (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.range "0" "9") ((_ re.loop 0 3) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; \b[A-Z0-9]{5}\d{1}[01567]\d{1}([0][1-9]|[12][0-9]|[3][0-1])\d{1}[A-Z0-9]{3}[A-Z]{2}\b
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re "1") (str.to_re "5") (str.to_re "6") (str.to_re "7")) ((_ re.loop 1 1) (re.range "0" "9")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; version\s+CodeguruBrowserwww\x2Esogou\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "version") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "CodeguruBrowserwww.sogou.com\u{0a}"))))
(check-sat)

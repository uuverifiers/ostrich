(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\s+information\swww\x2Etopadwarereviews\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "information") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.topadwarereviews.com\u{0a}")))))
; action\x2EIP-FTPsearch\.dropspam\.com
(assert (str.in_re X (str.to_re "action.IP-FTPsearch.dropspam.com\u{0a}")))
; ^[3|4|5|6]([0-9]{15}$|[0-9]{12}$|[0-9]{13}$|[0-9]{14}$)
(assert (str.in_re X (re.++ (re.union (str.to_re "3") (str.to_re "|") (str.to_re "4") (str.to_re "5") (str.to_re "6")) (re.union ((_ re.loop 15 15) (re.range "0" "9")) ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9")) ((_ re.loop 14 14) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{1}\w{1,3}) (\d{1}[A-Z]{2})$
(assert (str.in_re X (re.++ (str.to_re " \u{0a}") ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")))))
; cdpViewWatcher\x2Fcgi\x2Flogurl\.cgiwww\x2Ebydou\x2Ecom
(assert (str.in_re X (str.to_re "cdpViewWatcher/cgi/logurl.cgiwww.bydou.com\u{0a}")))
; /filename=[^\n]*\u{2e}jpeg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpeg/i\u{0a}")))))
; /X-ID\u{3a}\s\u{30}\u{30}+[0-9a-f]{20}(\r\n)+/iH
(assert (not (str.in_re X (re.++ (str.to_re "/X-ID:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "0") (re.+ (str.to_re "0")) ((_ re.loop 20 20) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.+ (str.to_re "\u{0d}\u{0a}")) (str.to_re "/iH\u{0a}")))))
; SecureNet\s+hostiedesksearch\.dropspam\.com
(assert (str.in_re X (re.++ (str.to_re "SecureNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hostiedesksearch.dropspam.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}\?[0-9a-f]{60,66}[\u{3b}\d]*$/U
(assert (not (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 60 66) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.* (re.union (str.to_re ";") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; config\x2E180solutions\x2Ecom\dStableWeb-MailUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "config.180solutions.com") (re.range "0" "9") (str.to_re "StableWeb-MailUser-Agent:\u{0a}")))))
; /filename=[^\n]*\u{2e}eps/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".eps/i\u{0a}"))))
(check-sat)
